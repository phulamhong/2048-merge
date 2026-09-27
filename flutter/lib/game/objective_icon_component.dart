import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'tile_look.dart';

/// One objective in the HUD: a small tile-shaped icon (emoji, same look as
/// the real tile it wants) plus a progress count underneath — replaces the
/// plain "Mục tiêu: Gà giò 2/3" text line so the goal reads visually instead
/// of needing to parse a sentence.
class ObjectiveIconComponent extends PositionComponent {
  final Look look;
  final int target;
  int progress;
  late final TextComponent _emojiLabel;
  late final TextComponent _countLabel;

  ObjectiveIconComponent({
    required this.look,
    required this.target,
    this.progress = 0,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.topLeft) {
    _emojiLabel = TextComponent(
      text: look.emoji,
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.x / 2),
      textRenderer: TextPaint(style: TextStyle(fontSize: size.x * 0.5)),
    );
    add(_emojiLabel);

    _countLabel = TextComponent(
      text: '$progress/$target',
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, size.x + 2),
      textRenderer: _countStyle(false),
    );
    add(_countLabel);
  }

  bool get isComplete => progress >= target;

  void updateProgress(int p) {
    progress = p;
    _countLabel.text = isComplete ? '✓' : '$progress/$target';
    _countLabel.textRenderer = _countStyle(isComplete);
  }

  TextPaint _countStyle(bool complete) => TextPaint(
    style: TextStyle(
      color: complete ? const Color(0xFF8FE388) : Colors.white70,
      fontSize: 13,
      fontWeight: complete ? FontWeight.bold : FontWeight.normal,
    ),
  );

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.x);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.x * 0.2));
    final bg = isComplete ? const Color(0xFF3D6B3F) : toFlutterColor(look.color);
    canvas.drawRRect(rrect, Paint()..color = bg.withValues(alpha: isComplete ? 0.9 : 0.85));
    if (isComplete) {
      canvas.drawRRect(rrect, Paint()
        ..color = const Color(0xFF8FE388)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2);
    }
  }
}
