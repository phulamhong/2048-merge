import { describe, expect, it } from 'vitest';
import { GameSession, starsFor } from '../../src/core/GameSession';
import { makeLevel, sessionWith, testChain, tiersGrid } from './helpers';

describe('swipe', () => {
  it('slides and merges in each direction like 2048', () => {
    const s = sessionWith([
      [1, 1, 0, 1],
      [0, 0, 0, 0],
    ]);
    s.swipe('left');
    expect(tiersGrid(s)).toEqual([
      [2, 1, 0, 0],
      [0, 0, 0, 0],
    ]);
    s.swipe('right');
    expect(tiersGrid(s)[0]).toEqual([0, 0, 2, 1]);
    s.swipe('down');
    expect(tiersGrid(s)[1]).toEqual([0, 0, 2, 1]);
    s.swipe('up');
    expect(tiersGrid(s)[0]).toEqual([0, 0, 2, 1]);
  });

  it('does not cost a move or spawn when nothing changes', () => {
    const s = sessionWith([[1, 2, 0, 0]], { spawn: { perTurn: 1 } });
    const events = s.swipe('left');
    expect(events).toEqual([{ type: 'noChange' }]);
    expect(s.movesUsed).toBe(0);
    expect(s.board.tiles()).toHaveLength(2);
  });

  it('spawns tier-1 tiles after a changing swipe', () => {
    const s = sessionWith([[0, 0, 0, 1]], { spawn: { perTurn: 1 } });
    const events = s.swipe('left');
    expect(events.filter((e) => e.type === 'spawn')).toHaveLength(1);
    expect(s.movesUsed).toBe(1);
  });

  it('auto-harvests over-merged tiles into coins in merge mode', () => {
    const s = sessionWith([[3, 3, 0, 0]], { objectives: [{ tier: 2, target: 1 }] });
    const events = s.swipe('left');
    expect(events.some((e) => e.type === 'harvest' && e.auto)).toBe(true);
    expect(s.board.tiles()).toHaveLength(0);
    expect(s.coins).toBeGreaterThan(0);
  });

  it('keeps over-merged tiles in split mode so they can be split again', () => {
    const s = sessionWith([[3, 3, 0, 0]], { mode: 'split', objectives: [{ tier: 1, target: 1 }] });
    s.swipe('left');
    expect(tiersGrid(s)[0]).toEqual([4, 0, 0, 0]);
  });
});

describe('tap', () => {
  it('harvests a needed tile without spending a move and wins', () => {
    const s = sessionWith([[3, 0, 0, 0]]);
    const events = s.tap(0, 0);
    expect(events[0]).toMatchObject({ type: 'harvest', auto: false, objectiveIndex: 0 });
    expect(s.movesUsed).toBe(0);
    expect(s.status).toBe('won');
  });

  it('rejects taps on unneeded tiles in merge mode', () => {
    const s = sessionWith([[2, 0, 0, 0]]);
    expect(s.tap(0, 0)).toEqual([{ type: 'invalid', uid: expect.any(Number), reason: 'notNeeded' }]);
  });

  it('splits into two lower tiles, preferring the right neighbour', () => {
    const s = sessionWith([[4, 0], [0, 0]], { mode: 'split', objectives: [{ tier: 1, target: 4 }] });
    s.tap(0, 0);
    expect(tiersGrid(s)).toEqual([
      [3, 3],
      [0, 0],
    ]);
    expect(s.movesUsed).toBe(1);
  });

  it('falls back to other neighbours, and refuses when boxed in', () => {
    const s = sessionWith([[1, 4], [0, 1]], { mode: 'split', objectives: [{ tier: 1, target: 9 }] });
    const boxed = s.tap(0, 1);
    expect(boxed[0]).toMatchObject({ type: 'invalid', reason: 'noSpace' });

    const t = sessionWith([[1, 4], [1, 0]], { mode: 'split', objectives: [{ tier: 2, target: 9 }] });
    t.tap(0, 1);
    expect(tiersGrid(t)).toEqual([
      [1, 3],
      [1, 3],
    ]);
  });

  it('harvest takes priority over split', () => {
    const s = sessionWith([[2, 0, 0, 0]], { mode: 'mixed', objectives: [{ tier: 2, target: 1 }] });
    expect(s.tap(0, 0)[0].type).toBe('harvest');
  });

  it('matches skin-specific objectives only with the right skin', () => {
    const skinned = {
      ...testChain,
      tiers: testChain.tiers.map((t) =>
        t.tier === 4
          ? { ...t, skins: [{ id: 'apple', name: 'A', emoji: '', color: 0, weight: 1 }] }
          : t,
      ),
    };
    const s = new GameSession(
      makeLevel({
        initialTiles: [{ tier: 4, row: 0, col: 0 }],
        objectives: [{ tier: 4, skinId: 'apple', target: 1 }],
      }),
      skinned,
      1,
    );
    expect(s.board.get(0, 0)?.skinId).toBe('apple');
    expect(s.tap(0, 0)[0].type).toBe('harvest');
  });
});

describe('lose conditions', () => {
  it('loses when the board is full with no merges', () => {
    const s = sessionWith(
      [
        [2, 1],
        [3, 0],
      ],
      { spawn: { perTurn: 1 }, objectives: [{ tier: 4, target: 1 }] },
    );
    s.swipe('right');
    // the only empty cell (1,0) gets a tier-1 spawn: [[2,1],[1,3]] has no merges
    expect(tiersGrid(s)).toEqual([
      [2, 1],
      [1, 3],
    ]);
    expect(s.status).toBe('lost');
    expect(s.loseReason).toBe('stuck');
  });

  it('loses when moves run out', () => {
    const s = sessionWith([[1, 0, 0, 0]], { moveLimit: 1, objectives: [{ tier: 4, target: 1 }] });
    s.swipe('right');
    expect(s.status).toBe('lost');
    expect(s.loseReason).toBe('outOfMoves');
  });

  it('still allows harvesting a needed tile at zero moves', () => {
    const s = sessionWith([[1, 1, 0, 0]], { moveLimit: 1, objectives: [{ tier: 2, target: 1 }] });
    s.swipe('left');
    expect(s.status).toBe('playing');
    s.tap(0, 0);
    expect(s.status).toBe('won');
  });
});

describe('stars', () => {
  it('awards 3/2/1 stars by fraction of moves left', () => {
    expect(starsFor(3, 10)).toBe(3);
    expect(starsFor(2, 10)).toBe(2);
    expect(starsFor(1, 10)).toBe(1);
  });
});

describe('clone', () => {
  it('is independent from the original', () => {
    const s = sessionWith([[1, 1, 0, 0]]);
    const c = s.clone();
    c.swipe('left');
    expect(tiersGrid(s)[0]).toEqual([1, 1, 0, 0]);
    expect(tiersGrid(c)[0]).toEqual([2, 0, 0, 0]);
  });
});
