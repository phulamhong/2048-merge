export type Direction = 'up' | 'down' | 'left' | 'right';
export type LevelMode = 'merge' | 'split' | 'mixed';

export interface SkinDef {
  id: string;
  name: string;
  emoji: string;
  color: number;
  weight: number;
}

export interface TierDef {
  tier: number;
  id: string;
  name: string;
  emoji: string;
  color: number;
  skins?: SkinDef[];
}

export interface ChainDef {
  id: string;
  name: string;
  tiers: TierDef[];
}

export interface ObjectiveDef {
  tier: number;
  skinId?: string;
  target: number;
}

export interface LevelConfig {
  id: string;
  name: string;
  chainId: string;
  mode: LevelMode;
  grid: { rows: number; cols: number };
  initialTiles?: { tier: number; row?: number; col?: number }[];
  /** Number of random tier-1 tiles placed at start (default 2 for merge/mixed, 0 for split). */
  initialRandom?: number;
  spawn: {
    /** Tier-1 tiles spawned after each swipe that changes the board. */
    perTurn: number;
    /** Chance (0..1) of spawning one extra tier-1 tile. */
    doubleChance?: number;
    bigTileEvery?: { turns: number; tier: number };
  };
  objectives: ObjectiveDef[];
  moveLimit: number;
  /** Fraction of moves left needed for 2 and 3 stars. */
  starThresholds?: [number, number];
  producesIngredient: string;
  boss?: boolean;
  hint?: string;
}

export interface IngredientDef {
  id: string;
  name: string;
  emoji: string;
}

export interface RecipeDef {
  id: string;
  name: string;
  verb: string;
  emoji: string;
  /** Emoji of the pot/workbench the ingredients fly into. */
  station: string;
  ingredients: IngredientDef[];
}

export interface DecorDef {
  id: string;
  name: string;
  emoji: string;
}

export interface ChapterDef {
  id: string;
  name: string;
  recipe: RecipeDef;
  levelIds: string[];
  unlocks: DecorDef[];
}

export type BornFrom = 'initial' | 'spawn' | 'merge' | 'split';

export interface Tile {
  uid: number;
  tier: number;
  skinId?: string;
  row: number;
  col: number;
  bornFrom: BornFrom;
}

export interface Pos {
  row: number;
  col: number;
}

export type InvalidReason = 'noSpace' | 'tier1' | 'notNeeded';

export type GameEvent =
  | { type: 'move'; uid: number; to: Pos }
  | { type: 'merge'; a: number; b: number; result: Tile }
  | { type: 'spawn'; tile: Tile }
  | { type: 'split'; kept: Tile; spawned: Tile }
  | { type: 'harvest'; tile: Tile; auto: boolean; objectiveIndex: number | null; coins: number }
  | { type: 'invalid'; uid: number; reason: InvalidReason }
  | { type: 'noChange' };

export type SessionStatus = 'playing' | 'won' | 'lost';
export type LoseReason = 'outOfMoves' | 'stuck';
