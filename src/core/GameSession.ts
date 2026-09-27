import { Board } from './Board';
import { ObjectiveTracker } from './ObjectiveTracker';
import { Rng } from './rng';
import type {
  ChainDef,
  Direction,
  GameEvent,
  LevelConfig,
  LoseReason,
  SessionStatus,
  Tile,
} from './types';

export const OVERFLOW_COINS_PER_TIER = 5;
const DEFAULT_STAR_THRESHOLDS: [number, number] = [0.15, 0.3];

export function starsFor(movesLeft: number, moveLimit: number, thresholds = DEFAULT_STAR_THRESHOLDS): 1 | 2 | 3 {
  const ratio = movesLeft / moveLimit;
  if (ratio >= thresholds[1]) return 3;
  if (ratio >= thresholds[0]) return 2;
  return 1;
}

/**
 * One play-through of a level. Pure game rules, no rendering: every action
 * mutates the model immediately and returns the events the view should replay.
 */
export class GameSession {
  readonly board: Board;
  readonly tracker: ObjectiveTracker;
  movesUsed = 0;
  coins = 0;
  status: SessionStatus = 'playing';
  loseReason: LoseReason | null = null;
  private readonly rng: Rng;

  constructor(
    readonly level: LevelConfig,
    readonly chain: ChainDef,
    seed = Date.now(),
  ) {
    this.rng = new Rng(seed);
    this.board = new Board(level.grid.rows, level.grid.cols, chain, this.rng);
    this.tracker = new ObjectiveTracker(level.objectives);
    for (const t of level.initialTiles ?? []) {
      if (t.row !== undefined && t.col !== undefined) {
        this.board.createTile(t.tier, { row: t.row, col: t.col }, 'initial');
      } else {
        this.board.spawnRandom(t.tier, 'initial');
      }
    }
    const initialRandom = level.initialRandom ?? (level.mode === 'split' ? 0 : 2);
    for (let i = 0; i < initialRandom; i++) this.board.spawnRandom(1, 'initial');
  }

  get movesLeft(): number {
    return Math.max(0, this.level.moveLimit - this.movesUsed);
  }

  get stars(): 1 | 2 | 3 {
    return starsFor(this.movesLeft, this.level.moveLimit, this.level.starThresholds);
  }

  get canSplit(): boolean {
    return this.level.mode !== 'merge';
  }

  isHarvestable(tile: Tile): boolean {
    return this.tracker.match(tile) !== null;
  }

  swipe(dir: Direction): GameEvent[] {
    if (this.status !== 'playing' || this.movesLeft <= 0) return [];
    const res = this.board.slide(dir);
    if (!res.changed) return [{ type: 'noChange' }];

    const events: GameEvent[] = [];
    for (const m of res.moves) events.push({ type: 'move', uid: m.uid, to: m.to });
    for (const m of res.merges) events.push({ type: 'merge', a: m.a, b: m.b, result: { ...m.result } });
    this.movesUsed++;

    for (const m of res.merges) this.autoHarvestIfOverflow(m.result, events);
    if (this.checkWin()) return events;

    const extra = this.level.spawn.doubleChance && this.rng.next() < this.level.spawn.doubleChance ? 1 : 0;
    for (let i = 0; i < this.level.spawn.perTurn + extra; i++) this.spawn(1, events);
    this.periodicSpawn(events);
    this.checkLose();
    return events;
  }

  /** Tap priority: harvest (free) → split (1 move) → invalid. */
  tap(row: number, col: number): GameEvent[] {
    if (this.status !== 'playing') return [];
    const tile = this.board.get(row, col);
    if (!tile) return [];

    const idx = this.tracker.match(tile);
    if (idx !== null) {
      this.board.remove(tile);
      this.tracker.add(idx);
      const events: GameEvent[] = [{ type: 'harvest', tile: { ...tile }, auto: false, objectiveIndex: idx, coins: 0 }];
      if (!this.checkWin()) this.checkLose();
      return events;
    }

    if (!this.canSplit) return [{ type: 'invalid', uid: tile.uid, reason: 'notNeeded' }];
    if (tile.tier <= 1) return [{ type: 'invalid', uid: tile.uid, reason: 'tier1' }];
    if (this.movesLeft <= 0) return [];
    const res = this.board.split(tile);
    if (!res) return [{ type: 'invalid', uid: tile.uid, reason: 'noSpace' }];

    const events: GameEvent[] = [{ type: 'split', kept: { ...res.kept }, spawned: { ...res.spawned } }];
    this.movesUsed++;
    this.periodicSpawn(events);
    this.checkLose();
    return events;
  }

  clone(): GameSession {
    const copy = Object.create(GameSession.prototype) as GameSession;
    const rng = this.rng.clone();
    Object.assign(copy, {
      level: this.level,
      chain: this.chain,
      rng,
      board: this.board.clone(rng),
      tracker: this.tracker.clone(),
      movesUsed: this.movesUsed,
      coins: this.coins,
      status: this.status,
      loseReason: this.loseReason,
    });
    return copy;
  }

  /**
   * Merge levels only: a freshly merged tile no unfinished objective accepts and
   * that can never grow into a needed tier is cashed in, so it cannot clog the board.
   */
  private autoHarvestIfOverflow(tile: Tile, events: GameEvent[]): void {
    if (this.level.mode !== 'merge') return;
    const maxActive = this.tracker.maxActiveTier();
    if (this.tracker.match(tile) !== null || tile.tier < maxActive) return;
    this.board.remove(tile);
    const coins = tile.tier * OVERFLOW_COINS_PER_TIER;
    this.coins += coins;
    events.push({ type: 'harvest', tile: { ...tile }, auto: true, objectiveIndex: null, coins });
  }

  private spawn(tier: number, events: GameEvent[]): void {
    const tile = this.board.spawnRandom(tier);
    if (tile) events.push({ type: 'spawn', tile: { ...tile } });
  }

  private periodicSpawn(events: GameEvent[]): void {
    const every = this.level.spawn.bigTileEvery;
    if (every && this.movesUsed % every.turns === 0) this.spawn(every.tier, events);
  }

  private checkWin(): boolean {
    if (!this.tracker.isComplete()) return false;
    this.status = 'won';
    return true;
  }

  private checkLose(): void {
    const tiles = this.board.tiles();
    const anyHarvestable = tiles.some((t) => this.isHarvestable(t));
    // With at least one tile and one empty cell, some swipe (and any split) is possible.
    const boardLocked = tiles.length === 0 || this.board.emptyCells().length === 0;
    if (this.movesLeft <= 0 && !anyHarvestable) {
      this.status = 'lost';
      this.loseReason = 'outOfMoves';
    } else if (boardLocked && !this.board.hasAdjacentMerge() && !anyHarvestable) {
      this.status = 'lost';
      this.loseReason = 'stuck';
    }
  }
}
