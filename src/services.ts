import { memoryStorage, SaveManager, type KeyValueStorage } from './core/SaveManager';
import { CHAPTERS } from './data/chapters';
import { LEVELS } from './data/levels';

function browserStorage(): KeyValueStorage {
  try {
    const probe = '__farm2048_probe';
    localStorage.setItem(probe, '1');
    localStorage.removeItem(probe);
    return localStorage;
  } catch {
    return memoryStorage();
  }
}

export const save = new SaveManager(browserStorage(), CHAPTERS, LEVELS);
