import { describe, expect, it } from 'vitest';
import { SaveManager, SAVE_KEY, memoryStorage } from '../../src/core/SaveManager';
import { CHAPTERS } from '../../src/data/chapters';
import { LEVELS } from '../../src/data/levels';

const fresh = () => new SaveManager(memoryStorage(), CHAPTERS, LEVELS);

describe('SaveManager', () => {
  it('unlocks levels sequentially and chapters after cooking', () => {
    const save = fresh();
    expect(save.isLevelUnlocked('1-1')).toBe(true);
    expect(save.isLevelUnlocked('1-2')).toBe(false);
    expect(save.isLevelUnlocked('2-1')).toBe(false);
    save.recordWin('1-1', 2, 0);
    expect(save.isLevelUnlocked('1-2')).toBe(true);
  });

  it('grants the ingredient only on first clear and keeps best stars', () => {
    const save = fresh();
    save.recordWin('1-1', 1, 0);
    save.recordWin('1-1', 3, 0);
    save.recordWin('1-1', 2, 0);
    expect(save.data.inventory.nest).toBe(1);
    expect(save.levelStars('1-1')).toBe(3);
    expect(save.data.coins).toBe(30);
  });

  it('cooks once all ingredients are collected and unlocks the next chapter', () => {
    const save = fresh();
    for (const id of CHAPTERS[0].levelIds) {
      expect(save.canCook('ch1')).toBe(false);
      save.recordWin(id, 1, 0);
    }
    expect(save.canCook('ch1')).toBe(true);
    expect(save.cook('ch1')).toBe(true);
    expect(save.data.decor).toContain('coop');
    expect(save.canCook('ch1')).toBe(false);
    expect(save.isLevelUnlocked('2-1')).toBe(true);
  });

  it('persists to storage and survives corrupt data', () => {
    const storage = memoryStorage();
    new SaveManager(storage, CHAPTERS, LEVELS).recordWin('1-1', 3, 5);
    expect(new SaveManager(storage, CHAPTERS, LEVELS).levelStars('1-1')).toBe(3);
    storage.setItem(SAVE_KEY, '{not json');
    expect(new SaveManager(storage, CHAPTERS, LEVELS).data.coins).toBe(0);
  });
});
