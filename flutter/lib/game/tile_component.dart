import 'package:flame/components.dart';
import 'package:flutter/material.dart';

const tierColors = [
  Color(0xFFB0B0B0),
  Color(0xFFEED4A1),
  Color(0xFFD9A659),
  Color(0xFFF28C40),
  Color(0xFFE65A4C),
  Color(0xFFB24CBF),
  Color(0xFF4C8CE6),
  Color(0xFF3CA65A),
];

Color colorForTier(int tier) => tierColors[tier.clamp(0, tierColors.length - 1)];

/// Visual for one board tile. Placeholder colored block + tier number,
/// matching the current web build (docs/SPECS.md: "chưa có asset, dùng emoji
/// + khối màu").
class TileComponent extends RectangleComponent {
  final int uid;
  int tier;
  late final TextComponent _label;

  TileComponent({required this.uid, required this.tier, required Vector2 size, required Vector2 position})
    : super(size: size, position: position, anchor: Anchor.topLeft) {
    paint.color = colorForTier(tier);
    _label = TextComponent(
      text: '$tier',
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(style: const TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold)),
    );
    add(_label);
  }

  void updateTier(int newTier) {
    tier = newTier;
    paint.color = colorForTier(tier);
    _label.text = '$newTier';
  }
}
