import { GameSession } from '../src/core/GameSession';
import type { ChainDef, Direction, LevelConfig } from '../src/core/types';
import { CHAINS } from '../src/data/chains';
import { LEVEL_LIST } from '../src/data/levels';

type Action = { kind: 'swipe'; dir: Direction } | { kind: 'tap'; row: number; col: number };
const DIRS: Direction[] = ['up', 'down', 'left', 'right'];
const RUNS = Number(process.argv[2] ?? 300);

function harvestAll(s: GameSession): void {
  for (const t of s.board.tiles()) if (s.status === 'playing' && s.isHarvestable(t)) s.tap(t.row, t.col);
}

function actions(s: GameSession): Action[] {
  const out: Action[] = DIRS.map((dir) => ({ kind: 'swipe', dir }));
  if (s.canSplit) {
    for (const t of s.board.tiles()) {
      if (t.tier > 1 && s.board.splitTarget(t)) out.push({ kind: 'tap', row: t.row, col: t.col });
    }
  }
  return out;
}

function apply(s: GameSession, a: Action): boolean {
  const events = a.kind === 'swipe' ? s.swipe(a.dir) : s.tap(a.row, a.col);
  return events.length > 0 && events[0].type !== 'noChange' && events[0].type !== 'invalid';
}

function score(s: GameSession): number {
  if (s.status === 'won') return 1e6 + s.movesLeft;
  if (s.status === 'lost') return -1e6;
  const m = s.tracker.maxActiveTier();
  let v = 0;
  s.tracker.objectives.forEach((o, i) => (v += 100 * s.tracker.progress[i] * 2 ** (o.tier - 1)));
  // Above the needed tier, 3^d penalty makes each split (1 tile → 2 tiles one tier lower) an improvement.
  for (const t of s.board.tiles()) v += t.tier <= m ? t.tier * t.tier : -2 * 3 ** (t.tier - m);
  v += 3 * s.board.emptyCells().length;
  return v;
}

type Bot = (s: GameSession, pickRandom: () => number) => void;

const randomBot: Bot = (s, rnd) => {
  harvestAll(s);
  if (s.status !== 'playing') return;
  const acts = actions(s);
  for (let tries = 0; tries < 10; tries++) if (apply(s, acts[Math.floor(rnd() * acts.length)])) return;
  for (const a of acts) if (apply(s, a)) return;
};

const greedyBot: Bot = (s, rnd) => {
  harvestAll(s);
  if (s.status !== 'playing') return;
  let best: Action | null = null;
  let bestScore = -Infinity;
  for (const a of actions(s)) {
    const c = s.clone();
    if (!apply(c, a)) continue;
    harvestAll(c);
    const sc = score(c) + rnd() * 0.5;
    if (sc > bestScore) {
      bestScore = sc;
      best = a;
    }
  }
  if (best) apply(s, best);
};

function play(level: LevelConfig, chain: ChainDef, bot: Bot, seed: number): GameSession {
  const s = new GameSession(level, chain, seed);
  let r = seed * 7919;
  const rnd = () => ((r = (r * 16807) % 2147483647) / 2147483647);
  for (let guard = 0; guard < 1000 && s.status === 'playing'; guard++) {
    const before = s.movesUsed + s.tracker.progress.reduce((a, b) => a + b, 0);
    bot(s, rnd);
    const after = s.movesUsed + s.tracker.progress.reduce((a, b) => a + b, 0);
    if (after === before && s.status === 'playing') break; // bot found nothing to do
  }
  return s;
}

/** Plan §4: minMoves for merge levels = Σ target × 2^(tier−1) ÷ skin probability. */
function mergeMinMoves(level: LevelConfig, chain: ChainDef): number | null {
  if (level.mode !== 'merge') return null;
  return level.objectives.reduce((sum, o) => {
    const skins = chain.tiers[o.tier - 1].skins;
    const p = o.skinId && skins ? skins.find((k) => k.id === o.skinId)!.weight / skins.reduce((a, k) => a + k.weight, 0) : 1;
    return sum + (o.target * 2 ** (o.tier - 1)) / p;
  }, 0);
}

const pct = (n: number) => `${Math.round(n * 100)}%`.padStart(5);
console.log(`Mô phỏng ${RUNS} ván/bot/màn\n`);
console.log('Màn   Kiểu   Lượt  minMoves  Random  Tham lam  Lượt TB (thắng)  Sao TB');
for (const level of LEVEL_LIST) {
  const chain = CHAINS[level.chainId];
  const stats = [randomBot, greedyBot].map((bot) => {
    let wins = 0;
    let moves = 0;
    let stars = 0;
    for (let i = 1; i <= RUNS; i++) {
      const s = play(level, chain, bot, i);
      if (s.status === 'won') {
        wins++;
        moves += s.movesUsed;
        stars += s.stars;
      }
    }
    return { rate: wins / RUNS, moves: wins ? moves / wins : 0, stars: wins ? stars / wins : 0 };
  });
  const mm = mergeMinMoves(level, chain);
  console.log(
    [
      level.id.padEnd(5),
      level.mode.padEnd(6),
      String(level.moveLimit).padStart(4),
      (mm === null ? '-' : mm.toFixed(0)).padStart(9),
      pct(stats[0].rate).padStart(7),
      pct(stats[1].rate).padStart(9),
      stats[1].moves.toFixed(1).padStart(16),
      stats[1].stars.toFixed(2).padStart(7),
    ].join(' '),
  );
}
