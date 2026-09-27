import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import 'tile_look.dart';

/// Visual for one board tile: colored rounded block with a soft shadow,
/// top-to-bottom gloss gradient and a light top highlight for a "3D button"
/// look, plus the ingredient emoji. Matches the current web build's approach
/// (Phaser TileView/theme.ts — "chưa có asset, dùng emoji + khối màu"), just
/// with more visual depth than a flat rectangle.
class TileComponent extends PositionComponent {
  final int uid;
  Look look;
  late RRect _rrect;
  late RRect _shadowRRect;
  late Paint _shadowPaint;
  late Gradient _fillGradient;
  late Paint _highlightPaint;
  late Rect _highlightRect;
  late final TextComponent _emojiLabel;

  TileComponent({required this.uid, required this.look, required Vector2 size, required Vector2 position})
    : super(size: size, position: position, anchor: Anchor.topLeft) {
    _applyLook();

    _emojiLabel = TextComponent(
      text: look.emoji,
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(style: TextStyle(fontSize: size.x * 0.46)),
    );
    add(_emojiLabel);
  }

  void _applyLook() {
    final base = toFlutterColor(look.color);
    final radius = Radius.circular(size.x * 0.18);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    _rrect = RRect.fromRectAndRadius(rect, radius);
    _shadowRRect = RRect.fromRectAndRadius(rect.shift(const Offset(0, 3)), radius);
    _shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    _fillGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [_lighten(base, 0.16), base, _darken(base, 0.12)],
      stops: const [0, 0.5, 1],
    );
    _highlightRect = Rect.fromLTWH(size.x * 0.1, size.y * 0.08, size.x * 0.8, size.y * 0.22);
    _highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.28);
  }

  void updateLook(Look newLook) {
    look = newLook;
    _applyLook();
    _emojiLabel.text = look.emoji;
  }

  // --- Animations ----------------------------------------------------
  // Mirrors the tween timings in src/view/BoardView.ts (MOVE_MS/POP_MS/FLY_MS)
  // so a swipe reads as tiles sliding/merging instead of teleporting.

  Future<void> _run(Effect effect) {
    final completer = Completer<void>();
    effect.onComplete = completer.complete;
    add(effect);
    return completer.future;
  }

  /// Slide to [pos] (a swipe move, or both tiles converging into a merge).
  Future<void> moveTo(Vector2 pos) =>
      _run(MoveToEffect(pos, EffectController(duration: 0.11, curve: Curves.easeOut)));

  /// Little bounce played on the surviving tile after a merge.
  Future<void> pop() => _run(
    ScaleEffect.to(Vector2.all(1.18), EffectController(duration: 0.07, reverseDuration: 0.07, curve: Curves.easeOut)),
  );

  /// Slide-and-grow into place, used for the new tile spawned by a split.
  Future<void> growTo(Vector2 pos) => Future.wait([
    _run(MoveToEffect(pos, EffectController(duration: 0.18, curve: Curves.easeOutBack))),
    _run(ScaleEffect.to(Vector2.all(1), EffectController(duration: 0.18, curve: Curves.easeOutBack))),
  ]).then((_) {});

  /// Pop-in used for a freshly spawned tier-1 tile.
  Future<void> spawnIn() {
    scale = Vector2.zero();
    return _run(ScaleEffect.to(Vector2.all(1), EffectController(duration: 0.15, curve: Curves.easeOutBack)));
  }

  /// Small side-to-side wobble for a rejected tap/split.
  Future<void> shake() => _run(
    MoveByEffect(Vector2(8, 0), EffectController(duration: 0.045, reverseDuration: 0.045, repeatCount: 2)),
  );

  /// Flies toward [target] (an objective icon or the coin counter) and
  /// shrinks away, played when a tile is harvested.
  Future<void> flyTo(Vector2 target) => Future.wait([
    _run(MoveToEffect(target, EffectController(duration: 0.38, curve: Curves.easeIn))),
    _run(ScaleEffect.to(Vector2.all(0.35), EffectController(duration: 0.38, curve: Curves.easeIn))),
  ]).then((_) {});

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_shadowRRect, _shadowPaint);
    final fillPaint = Paint()..shader = _fillGradient.createShader(Rect.fromLTWH(0, 0, size.x, size.y));
    canvas.drawRRect(_rrect, fillPaint);
    canvas.save();
    canvas.clipRRect(_rrect);
    canvas.drawRRect(RRect.fromRectAndRadius(_highlightRect, Radius.circular(size.x * 0.3)), _highlightPaint);
    canvas.restore();
  }

  static Color _lighten(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  static Color _darken(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}
