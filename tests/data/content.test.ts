import { describe, expect, it } from 'vitest';
import { CHAINS } from '../../src/data/chains';
import { CHAPTERS } from '../../src/data/chapters';
import { LEVEL_LIST, LEVELS } from '../../src/data/levels';

describe('content data', () => {
  it.each(LEVEL_LIST.map((l) => [l.id, l] as const))('level %s is consistent', (_, level) => {
    const chain = CHAINS[level.chainId];
    expect(chain, `chain ${level.chainId}`).toBeDefined();
    for (const o of level.objectives) {
      expect(o.tier).toBeGreaterThanOrEqual(1);
      expect(o.tier).toBeLessThanOrEqual(chain.tiers.length);
      if (o.skinId) expect(chain.tiers[o.tier - 1].skins?.map((s) => s.id)).toContain(o.skinId);
    }
    const seen = new Set<string>();
    for (const t of level.initialTiles ?? []) {
      expect(t.tier).toBeLessThanOrEqual(chain.tiers.length);
      if (t.row === undefined || t.col === undefined) continue;
      expect(t.row).toBeLessThan(level.grid.rows);
      expect(t.col).toBeLessThan(level.grid.cols);
      expect(seen.has(`${t.row},${t.col}`)).toBe(false);
      seen.add(`${t.row},${t.col}`);
    }
    expect(level.moveLimit).toBeGreaterThan(0);
  });

  it.each(CHAPTERS.map((c) => [c.id, c] as const))('chapter %s recipe is producible', (_, chapter) => {
    const produced = chapter.levelIds.map((id) => {
      expect(LEVELS[id], `level ${id}`).toBeDefined();
      return LEVELS[id].producesIngredient;
    });
    for (const ing of chapter.recipe.ingredients) expect(produced).toContain(ing.id);
  });
});
