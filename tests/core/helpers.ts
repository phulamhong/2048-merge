import { GameSession } from '../../src/core/GameSession';
import type { ChainDef, LevelConfig } from '../../src/core/types';

export const testChain: ChainDef = {
  id: 'test',
  name: 'Test',
  tiers: [1, 2, 3, 4].map((tier) => ({ tier, id: `t${tier}`, name: `T${tier}`, emoji: '', color: 0 })),
};

export function makeLevel(overrides: Partial<LevelConfig> = {}): LevelConfig {
  return {
    id: 'test',
    name: 'Test',
    chainId: 'test',
    mode: 'merge',
    grid: { rows: 4, cols: 4 },
    spawn: { perTurn: 0 },
    initialRandom: 0,
    objectives: [{ tier: 3, target: 1 }],
    moveLimit: 20,
    producesIngredient: 'x',
    ...overrides,
  };
}

/** Session with an exact layout: rows of tiers, 0 = empty. */
export function sessionWith(layout: number[][], overrides: Partial<LevelConfig> = {}): GameSession {
  const initialTiles = layout.flatMap((r, row) =>
    r.flatMap((tier, col) => (tier > 0 ? [{ tier, row, col }] : [])),
  );
  return new GameSession(
    makeLevel({ grid: { rows: layout.length, cols: layout[0].length }, initialTiles, ...overrides }),
    testChain,
    42,
  );
}

export function tiersGrid(s: GameSession): number[][] {
  return s.board.cells.map((r) => r.map((t) => (t ? t.tier : 0)));
}
