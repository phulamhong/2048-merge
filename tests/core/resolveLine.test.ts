import { describe, expect, it } from 'vitest';
import { resolveLine, type LineSlot } from '../../src/core/resolveLine';

type T = { tier: number };
const line = (...tiers: (number | null)[]) => tiers.map((t) => (t === null ? null : { tier: t }));
const canMerge = (a: T, b: T) => a.tier === b.tier && a.tier < 5;
const tiersOf = (slots: LineSlot<T>[]) => slots.map((s) => ('tile' in s ? s.tile.tier : s.merge[0].tier + 1));

describe('resolveLine', () => {
  it('merges pairs once per move: [1,1,1,1] → [2,2]', () => {
    expect(tiersOf(resolveLine(line(1, 1, 1, 1), canMerge))).toEqual([2, 2]);
  });

  it('does not chain merges: [1,1,2] → [2,2]', () => {
    expect(tiersOf(resolveLine(line(1, 1, 2, null), canMerge))).toEqual([2, 2]);
  });

  it('compacts across gaps: [null,1,null,1] → [2]', () => {
    expect(tiersOf(resolveLine(line(null, 1, null, 1), canMerge))).toEqual([2]);
  });

  it('merges the leading pair first: [2,2,2] → [3,2]', () => {
    expect(tiersOf(resolveLine(line(2, 2, 2, null), canMerge))).toEqual([3, 2]);
  });

  it('never merges the cap tier', () => {
    expect(tiersOf(resolveLine(line(5, 5, null, null), canMerge))).toEqual([5, 5]);
  });
});
