import '../core/types.dart';

/// Ported from src/data/chapters.ts.
final List<ChapterDef> chapters = [
  const ChapterDef(
    id: 'ch1',
    name: 'Chương 1 · Trại gà nhỏ',
    levelIds: ['1-1', '1-2', '1-3', '1-4', '1-5'],
    recipe: RecipeDef(
      id: 'coop',
      name: 'Chuồng gà',
      verb: 'Dựng',
      emoji: '🛖',
      station: '🧱',
      ingredients: [
        IngredientDef(id: 'nest', name: 'Ổ trứng', emoji: '🥚'),
        IngredientDef(id: 'flock', name: 'Đàn gà giò', emoji: '🐥'),
        IngredientDef(id: 'hen', name: 'Gà mái đẻ', emoji: '🐔'),
        IngredientDef(id: 'hens', name: 'Cặp gà mái', emoji: '🐔'),
        IngredientDef(id: 'rooster', name: 'Gà trống', emoji: '🐓'),
      ],
    ),
    unlocks: [DecorDef(id: 'coop', name: 'Chuồng gà', emoji: '🛖')],
  ),
  const ChapterDef(
    id: 'ch2',
    name: 'Chương 2 · Tô phở bò',
    levelIds: ['2-1', '2-2', '2-3', '2-4', '2-5'],
    recipe: RecipeDef(
      id: 'pho',
      name: 'Tô phở bò',
      verb: 'Nấu',
      emoji: '🍜',
      station: '🍲',
      ingredients: [
        IngredientDef(id: 'noodle', name: 'Bánh phở', emoji: '🍜'),
        IngredientDef(id: 'herbs', name: 'Rau thơm', emoji: '🌿'),
        IngredientDef(id: 'beef', name: 'Thịt bò tái', emoji: '🥩'),
        IngredientDef(id: 'broth', name: 'Nước dùng', emoji: '🫕'),
        IngredientDef(id: 'spice', name: 'Gia vị', emoji: '⭐'),
      ],
    ),
    unlocks: [DecorDef(id: 'pho_stall', name: 'Quán phở', emoji: '🏮')],
  ),
];
