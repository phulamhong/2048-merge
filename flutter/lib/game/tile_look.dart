import 'package:flutter/material.dart';

import '../core/types.dart';

/// Ported from src/view/theme.ts (lookOf/textColorFor) so tiles render the
/// same emoji/name/color as the web build instead of a generic tier palette.
class Look {
  final String emoji;
  final String name;
  final int color;
  const Look({required this.emoji, required this.name, required this.color});
}

Look lookOf(ChainDef chain, int tier, [String? skinId]) {
  final def = chain.tiers[tier - 1];
  final skin = skinId != null ? def.skins?.where((s) => s.id == skinId).firstOrNull : null;
  if (skin != null) return Look(emoji: skin.emoji, name: skin.name, color: skin.color);
  return Look(emoji: def.emoji, name: def.name, color: def.color);
}

/// The look an objective's icon should use — same tile art as the tier/skin
/// it asks for. Ported from src/view/theme.ts (objectiveLook).
Look objectiveLookOf(ChainDef chain, ObjectiveDef o) => lookOf(chain, o.tier, o.skinId);

/// Dark text on light tiles, white on dark ones.
Color textColorFor(int color) {
  final r = (color >> 16) & 0xff;
  final g = (color >> 8) & 0xff;
  final b = color & 0xff;
  final luminance = 0.299 * r + 0.587 * g + 0.114 * b;
  return luminance > 150 ? const Color(0xFF3D2C1E) : Colors.white;
}

Color toFlutterColor(int rgb) => Color(0xFF000000 | rgb);
