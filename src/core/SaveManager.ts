import type { ChapterDef, LevelConfig } from './types';

export interface KeyValueStorage {
  getItem(key: string): string | null;
  setItem(key: string, value: string): void;
}

export interface SaveData {
  version: 1;
  levels: Record<string, { stars: number }>;
  inventory: Record<string, number>;
  cooked: string[];
  decor: string[];
  coins: number;
}

export const SAVE_KEY = 'farm2048.save.v1';
const STAR_COINS = 10;

export function emptySave(): SaveData {
  return { version: 1, levels: {}, inventory: {}, cooked: [], decor: [], coins: 0 };
}

export function memoryStorage(): KeyValueStorage {
  const map = new Map<string, string>();
  return { getItem: (k) => map.get(k) ?? null, setItem: (k, v) => void map.set(k, v) };
}

/** Player progress: unlocks, stars, ingredient inventory, cooking. */
export class SaveManager {
  data: SaveData;

  constructor(
    private readonly storage: KeyValueStorage,
    private readonly chapters: readonly ChapterDef[],
    private readonly levels: Readonly<Record<string, LevelConfig>>,
  ) {
    this.data = this.load();
  }

  isChapterUnlocked(chapterId: string): boolean {
    const idx = this.chapters.findIndex((c) => c.id === chapterId);
    return idx === 0 || (idx > 0 && this.isCooked(this.chapters[idx - 1].id));
  }

  isLevelUnlocked(levelId: string): boolean {
    const chapter = this.chapters.find((c) => c.levelIds.includes(levelId));
    if (!chapter || !this.isChapterUnlocked(chapter.id)) return false;
    const idx = chapter.levelIds.indexOf(levelId);
    return idx === 0 || this.isLevelCleared(chapter.levelIds[idx - 1]);
  }

  isLevelCleared(levelId: string): boolean {
    return (this.data.levels[levelId]?.stars ?? 0) > 0;
  }

  levelStars(levelId: string): number {
    return this.data.levels[levelId]?.stars ?? 0;
  }

  isCooked(chapterId: string): boolean {
    return this.data.cooked.includes(chapterId);
  }

  /** Ingredients are granted only on the first clear; replays can only raise stars. */
  recordWin(levelId: string, stars: number, levelCoins: number): { firstClear: boolean; coinsEarned: number } {
    const level = this.levels[levelId];
    const firstClear = !this.isLevelCleared(levelId);
    const prevStars = this.levelStars(levelId);
    const coinsEarned = levelCoins + Math.max(0, stars - prevStars) * STAR_COINS;
    if (firstClear && level) {
      const ing = level.producesIngredient;
      this.data.inventory[ing] = (this.data.inventory[ing] ?? 0) + 1;
    }
    this.data.levels[levelId] = { stars: Math.max(prevStars, stars) };
    this.data.coins += coinsEarned;
    this.persist();
    return { firstClear, coinsEarned };
  }

  canCook(chapterId: string): boolean {
    const chapter = this.chapters.find((c) => c.id === chapterId);
    if (!chapter || this.isCooked(chapterId)) return false;
    return chapter.recipe.ingredients.every((i) => (this.data.inventory[i.id] ?? 0) >= 1);
  }

  cook(chapterId: string): boolean {
    const chapter = this.chapters.find((c) => c.id === chapterId);
    if (!chapter || !this.canCook(chapterId)) return false;
    for (const i of chapter.recipe.ingredients) this.data.inventory[i.id]--;
    this.data.cooked.push(chapterId);
    for (const d of chapter.unlocks) if (!this.data.decor.includes(d.id)) this.data.decor.push(d.id);
    this.persist();
    return true;
  }

  reset(): void {
    this.data = emptySave();
    this.persist();
  }

  private load(): SaveData {
    try {
      const raw = this.storage.getItem(SAVE_KEY);
      if (!raw) return emptySave();
      const parsed = JSON.parse(raw) as SaveData;
      return parsed.version === 1 ? { ...emptySave(), ...parsed } : emptySave();
    } catch {
      return emptySave();
    }
  }

  private persist(): void {
    try {
      this.storage.setItem(SAVE_KEY, JSON.stringify(this.data));
    } catch {
      // Storage full or blocked: progress stays in memory for this session.
    }
  }
}
