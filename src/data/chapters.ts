import type { ChapterDef } from '../core/types';

export const CHAPTERS: ChapterDef[] = [
  {
    id: 'ch1',
    name: 'Chương 1 · Trại gà nhỏ',
    levelIds: ['1-1', '1-2', '1-3', '1-4', '1-5'],
    recipe: {
      id: 'coop',
      name: 'Chuồng gà',
      verb: 'Dựng',
      emoji: '🛖',
      station: '🧱',
      ingredients: [
        { id: 'nest', name: 'Ổ trứng', emoji: '🥚' },
        { id: 'flock', name: 'Đàn gà giò', emoji: '🐥' },
        { id: 'hen', name: 'Gà mái đẻ', emoji: '🐔' },
        { id: 'hens', name: 'Cặp gà mái', emoji: '🐔' },
        { id: 'rooster', name: 'Gà trống', emoji: '🐓' },
      ],
    },
    unlocks: [{ id: 'coop', name: 'Chuồng gà', emoji: '🛖' }],
  },
  {
    id: 'ch2',
    name: 'Chương 2 · Tô phở bò',
    levelIds: ['2-1', '2-2', '2-3', '2-4', '2-5'],
    recipe: {
      id: 'pho',
      name: 'Tô phở bò',
      verb: 'Nấu',
      emoji: '🍜',
      station: '🍲',
      ingredients: [
        { id: 'noodle', name: 'Bánh phở', emoji: '🍜' },
        { id: 'herbs', name: 'Rau thơm', emoji: '🌿' },
        { id: 'beef', name: 'Thịt bò tái', emoji: '🥩' },
        { id: 'broth', name: 'Nước dùng', emoji: '🫕' },
        { id: 'spice', name: 'Gia vị', emoji: '⭐' },
      ],
    },
    unlocks: [{ id: 'pho_stall', name: 'Quán phở', emoji: '🏮' }],
  },
];
