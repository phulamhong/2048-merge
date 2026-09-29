import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

/// Visual for one "Hư hao" (decay) obstacle cell: a dashed-border patch with
/// a cobweb emoji and a small hit counter, turning red/urgent once heavy.
/// Simpler than [TileComponent] on purpose — obstacles don't slide or merge,
/// they only spawn, get hit, clear or escalate.
class ObstacleComponent extends PositionComponent {
  bool heavy;
  int hits;
  late RRect _rrect;
  late final TextComponent _emojiLabel;
  late final TextComponent _hitsLabel;

  ObstacleComponent({required Vector2 size, required Vector2 position, required this.heavy, required this.hits})
    : super(size: size, position: position, anchor: Anchor.topLeft) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    _rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.x * 0.16));

    _emojiLabel = TextComponent(
      text: heavy ? '🕸️‼️' : '🕸️',
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y * 0.42),
      textRenderer: TextPaint(style: TextStyle(fontSize: size.x * 0.4)),
    );
    add(_emojiLabel);

    _hitsLabel = TextComponent(
      text: heavy ? '' : '$hits/5',
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y * 0.82),
      textRenderer: TextPaint(style: TextStyle(fontSize: size.x * 0.16, color: Colors.white70)),
    );
    add(_hitsLabel);
  }

  void updateState({required bool heavy, required int hits}) {
    this.heavy = heavy;
    this.hits = hits;
    _emojiLabel.text = heavy ? '🕸️‼️' : '🕸️';
    _hitsLabel.text = heavy ? '' : '$hits/5';
  }

  Future<void> _run(Effect effect) {
    final completer = Completer<void>();
    effect.onComplete = completer.complete;
    add(effect);
    return completer.future;
  }

  /// Small shake played when the obstacle is hit but not yet cleared.
  Future<void> shake() =>
      _run(MoveByEffect(Vector2(6, 0), EffectController(duration: 0.04, reverseDuration: 0.04, repeatCount: 2)));

  /// Shrink-away played when the obstacle clears (hit 5 times, or repaired).
  Future<void> clearOut() => _run(ScaleEffect.to(Vector2.zero(), EffectController(duration: 0.2, curve: Curves.easeIn)));

  /// Pop-in played when a new obstacle spawns.
  Future<void> spawnIn() {
    scale = Vector2.zero();
    return _run(ScaleEffect.to(Vector2.all(1), EffectController(duration: 0.15, curve: Curves.easeOutBack)));
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = (heavy ? const Color(0xFFB23A2E) : const Color(0xFF8A7A5C)).withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(_rrect, paint);
  }
}
