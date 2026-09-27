import type { ChainDef, ObjectiveDef, Tile } from '../core/types';

export const WIDTH = 720;
export const HEIGHT = 1280;

export const FONT = '"Segoe UI", "Segoe UI Emoji", "Apple Color Emoji", "Noto Color Emoji", Arial, sans-serif';

export const COLORS = {
  bg: 0xf3e9d2,
  panel: 0xfffaf0,
  panelEdge: 0xd9c49c,
  board: 0xb08a55,
  cell: 0xd9c08e,
  accent: 0x6a994e,
  accentDark: 0x4f7a37,
  warm: 0xe76f51,
  disabled: 0xbdb2a0,
  text: '#3d2c1e',
  textMuted: '#8a7560',
  textLight: '#ffffff',
  gold: '#c98a00',
};

export interface Look {
  emoji: string;
  name: string;
  color: number;
}

export function lookOf(chain: ChainDef, tier: number, skinId?: string): Look {
  const def = chain.tiers[tier - 1];
  const skin = skinId ? def.skins?.find((s) => s.id === skinId) : undefined;
  return skin ? { emoji: skin.emoji, name: skin.name, color: skin.color } : { emoji: def.emoji, name: def.name, color: def.color };
}

export const tileLook = (chain: ChainDef, t: Pick<Tile, 'tier' | 'skinId'>) => lookOf(chain, t.tier, t.skinId);
export const objectiveLook = (chain: ChainDef, o: ObjectiveDef) => lookOf(chain, o.tier, o.skinId);

/** Dark text on light tiles, white on dark ones. */
export function textColorFor(color: number): string {
  const r = (color >> 16) & 0xff;
  const g = (color >> 8) & 0xff;
  const b = color & 0xff;
  return 0.299 * r + 0.587 * g + 0.114 * b > 150 ? COLORS.text : COLORS.textLight;
}

export function starString(stars: number, max = 3): string {
  return '★'.repeat(stars) + '☆'.repeat(max - stars);
}
