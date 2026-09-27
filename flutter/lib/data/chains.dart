import '../core/types.dart';

/// Ported from src/data/chains.ts.
const poultry = ChainDef(
  id: 'poultry',
  name: 'Gia cầm',
  tiers: [
    TierDef(tier: 1, id: 'egg', name: 'Trứng', emoji: '🥚', color: 0xfff4d6),
    TierDef(tier: 2, id: 'chick', name: 'Gà con', emoji: '🐣', color: 0xffe08a),
    TierDef(tier: 3, id: 'young', name: 'Gà giò', emoji: '🐥', color: 0xffc94d),
    TierDef(tier: 4, id: 'hen', name: 'Gà mái', emoji: '🐔', color: 0xf4a259),
    TierDef(tier: 5, id: 'rooster', name: 'Gà trống', emoji: '🐓', color: 0xe76f51),
  ],
);

const rice = ChainDef(
  id: 'rice',
  name: 'Lúa gạo',
  tiers: [
    TierDef(tier: 1, id: 'grain', name: 'Hạt gạo', emoji: '🍚', color: 0xfaf3e0),
    TierDef(tier: 2, id: 'stalk', name: 'Bông lúa', emoji: '🌾', color: 0xf1e3a1),
    TierDef(tier: 3, id: 'sack', name: 'Bao gạo', emoji: '🛍️', color: 0xe9c46a),
    TierDef(tier: 4, id: 'flour', name: 'Bột gạo', emoji: '🥣', color: 0xd4a373),
    TierDef(tier: 5, id: 'noodle', name: 'Bánh phở', emoji: '🍜', color: 0xbc6c25),
  ],
);

const herbs = ChainDef(
  id: 'herbs',
  name: 'Rau thơm',
  tiers: [
    TierDef(tier: 1, id: 'seed', name: 'Hạt giống', emoji: '🫘', color: 0xe9edc9),
    TierDef(tier: 2, id: 'sprout', name: 'Mầm', emoji: '🌱', color: 0xccd5ae),
    TierDef(tier: 3, id: 'plant', name: 'Cây non', emoji: '🪴', color: 0xa3b18a),
    TierDef(
      tier: 4,
      id: 'bunch',
      name: 'Bó rau',
      emoji: '🥬',
      color: 0x588157,
      skins: [
        SkinDef(id: 'scallion', name: 'Hành lá', emoji: '🧅', color: 0x6a994e, weight: 50),
        SkinDef(id: 'cilantro', name: 'Ngò', emoji: '🌿', color: 0x386641, weight: 30),
        SkinDef(id: 'basil', name: 'Húng quế', emoji: '🍃', color: 0x7f5539, weight: 20),
      ],
    ),
  ],
);

/// Split chain: players start from the cow and cut it down to slices.
const beef = ChainDef(
  id: 'beef',
  name: 'Thịt bò',
  tiers: [
    TierDef(tier: 1, id: 'slice', name: 'Lát bò tái', emoji: '🥓', color: 0xffcdb2),
    TierDef(tier: 2, id: 'loin', name: 'Miếng thăn', emoji: '🥩', color: 0xffb4a2),
    TierDef(tier: 3, id: 'chunk', name: 'Tảng thịt', emoji: '🍖', color: 0xe5989b),
    TierDef(tier: 4, id: 'leg', name: 'Đùi bò', emoji: '🍗', color: 0xb5838d),
    TierDef(tier: 5, id: 'cow', name: 'Con bò', emoji: '🐄', color: 0x6d6875),
  ],
);

const broth = ChainDef(
  id: 'broth',
  name: 'Nước dùng',
  tiers: [
    TierDef(tier: 1, id: 'bone', name: 'Xương', emoji: '🦴', color: 0xf8f9fa),
    TierDef(tier: 2, id: 'bonepot', name: 'Nồi xương', emoji: '🥘', color: 0xdee2e6),
    TierDef(tier: 3, id: 'simmer', name: 'Nồi ninh', emoji: '🍲', color: 0xadb5bd),
    TierDef(tier: 4, id: 'stock', name: 'Nồi nước dùng', emoji: '🫕', color: 0x8d99ae),
    TierDef(tier: 5, id: 'barrel', name: 'Thùng lớn', emoji: '🛢️', color: 0x5c677d),
  ],
);

const spice = ChainDef(
  id: 'spice',
  name: 'Gia vị',
  tiers: [
    TierDef(tier: 1, id: 'nut', name: 'Hạt', emoji: '🌰', color: 0xf5ebe0),
    TierDef(tier: 2, id: 'sprout', name: 'Mầm', emoji: '🌱', color: 0xe3d5ca),
    TierDef(tier: 3, id: 'tree', name: 'Cây gia vị', emoji: '🌳', color: 0xd5bdaf),
    TierDef(
      tier: 4,
      id: 'spice',
      name: 'Gia vị',
      emoji: '🧂',
      color: 0x9c6644,
      skins: [
        SkinDef(id: 'cinnamon', name: 'Quế', emoji: '🪵', color: 0x9c6644, weight: 40),
        SkinDef(id: 'anise', name: 'Hồi', emoji: '⭐', color: 0x7f4f24, weight: 35),
        SkinDef(id: 'cardamom', name: 'Thảo quả', emoji: '🫒', color: 0x582f0e, weight: 25),
      ],
    ),
  ],
);

final Map<String, ChainDef> chains = {for (final c in [poultry, rice, herbs, beef, broth, spice]) c.id: c};
