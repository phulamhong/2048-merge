import { resolveLine } from './resolveLine';
import type { Rng } from './rng';
import type { BornFrom, ChainDef, Direction, Pos, Tile } from './types';

export interface SlideResult {
  moves: { uid: number; to: Pos }[];
  merges: { a: number; b: number; result: Tile }[];
  changed: boolean;
}

const SPLIT_DIRECTIONS: Pos[] = [
  { row: 0, col: 1 },
  { row: 1, col: 0 },
  { row: 0, col: -1 },
  { row: -1, col: 0 },
];

export class Board {
  readonly cells: (Tile | null)[][];
  private nextUid = 1;

  constructor(
    readonly rows: number,
    readonly cols: number,
    private readonly chain: ChainDef,
    private readonly rng: Rng,
  ) {
    this.cells = Array.from({ length: rows }, () => Array<Tile | null>(cols).fill(null));
  }

  get maxTier(): number {
    return this.chain.tiers.length;
  }

  get(row: number, col: number): Tile | null {
    return this.inBounds(row, col) ? this.cells[row][col] : null;
  }

  tiles(): Tile[] {
    return this.cells.flat().filter((t): t is Tile => t !== null);
  }

  findByUid(uid: number): Tile | null {
    return this.tiles().find((t) => t.uid === uid) ?? null;
  }

  emptyCells(): Pos[] {
    const out: Pos[] = [];
    for (let row = 0; row < this.rows; row++) {
      for (let col = 0; col < this.cols; col++) {
        if (!this.cells[row][col]) out.push({ row, col });
      }
    }
    return out;
  }

  createTile(tier: number, pos: Pos, bornFrom: BornFrom): Tile {
    const tile: Tile = { uid: this.nextUid++, tier, row: pos.row, col: pos.col, bornFrom };
    const skinId = this.rollSkin(tier);
    if (skinId) tile.skinId = skinId;
    this.cells[pos.row][pos.col] = tile;
    return tile;
  }

  remove(tile: Tile): void {
    if (this.cells[tile.row][tile.col] === tile) this.cells[tile.row][tile.col] = null;
  }

  spawnRandom(tier: number, bornFrom: BornFrom = 'spawn'): Tile | null {
    const empty = this.emptyCells();
    if (empty.length === 0) return null;
    return this.createTile(tier, this.rng.pick(empty), bornFrom);
  }

  canMerge(a: Tile, b: Tile): boolean {
    return a.tier === b.tier && a.tier < this.maxTier;
  }

  slide(dir: Direction): SlideResult {
    const moves: SlideResult['moves'] = [];
    const merges: SlideResult['merges'] = [];
    for (const line of this.linesFor(dir)) {
      const slots = resolveLine(
        line.map((p) => this.cells[p.row][p.col]),
        (a, b) => this.canMerge(a, b),
      );
      for (const p of line) this.cells[p.row][p.col] = null;
      slots.forEach((slot, idx) => {
        const to = line[idx];
        if ('tile' in slot) {
          const t = slot.tile;
          if (t.row !== to.row || t.col !== to.col) moves.push({ uid: t.uid, to: { ...to } });
          t.row = to.row;
          t.col = to.col;
          this.cells[to.row][to.col] = t;
        } else {
          const [a, b] = slot.merge;
          const result = this.createTile(a.tier + 1, to, 'merge');
          merges.push({ a: a.uid, b: b.uid, result });
        }
      });
    }
    return { moves, merges, changed: moves.length > 0 || merges.length > 0 };
  }

  /** Free neighbour a split would use (right, down, left, up), or null. */
  splitTarget(tile: Tile): Pos | null {
    for (const d of SPLIT_DIRECTIONS) {
      const row = tile.row + d.row;
      const col = tile.col + d.col;
      if (this.inBounds(row, col) && !this.cells[row][col]) return { row, col };
    }
    return null;
  }

  split(tile: Tile): { kept: Tile; spawned: Tile } | null {
    if (tile.tier <= 1) return null;
    const target = this.splitTarget(tile);
    if (!target) return null;
    const newTier = tile.tier - 1;
    tile.tier = newTier;
    tile.bornFrom = 'split';
    const skinId = this.rollSkin(newTier);
    if (skinId) tile.skinId = skinId;
    else delete tile.skinId;
    const spawned = this.createTile(newTier, target, 'split');
    return { kept: tile, spawned };
  }

  hasAdjacentMerge(): boolean {
    for (let row = 0; row < this.rows; row++) {
      for (let col = 0; col < this.cols; col++) {
        const t = this.cells[row][col];
        if (!t) continue;
        const right = this.get(row, col + 1);
        const down = this.get(row + 1, col);
        if ((right && this.canMerge(t, right)) || (down && this.canMerge(t, down))) return true;
      }
    }
    return false;
  }

  clone(rng: Rng): Board {
    const copy = new Board(this.rows, this.cols, this.chain, rng);
    copy.nextUid = this.nextUid;
    for (const t of this.tiles()) copy.cells[t.row][t.col] = { ...t };
    return copy;
  }

  private rollSkin(tier: number): string | undefined {
    const skins = this.chain.tiers[tier - 1]?.skins;
    return skins && skins.length > 0 ? this.rng.weighted(skins).id : undefined;
  }

  private inBounds(row: number, col: number): boolean {
    return row >= 0 && row < this.rows && col >= 0 && col < this.cols;
  }

  /** Lines of cell positions, each ordered from the edge tiles slide toward. */
  private linesFor(dir: Direction): Pos[][] {
    const lines: Pos[][] = [];
    if (dir === 'left' || dir === 'right') {
      for (let row = 0; row < this.rows; row++) {
        const line = Array.from({ length: this.cols }, (_, col) => ({ row, col }));
        lines.push(dir === 'left' ? line : line.reverse());
      }
    } else {
      for (let col = 0; col < this.cols; col++) {
        const line = Array.from({ length: this.rows }, (_, row) => ({ row, col }));
        lines.push(dir === 'up' ? line : line.reverse());
      }
    }
    return lines;
  }
}
