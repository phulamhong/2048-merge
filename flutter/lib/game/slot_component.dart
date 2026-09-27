import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Empty grid cell: a recessed "socket" look (dark-to-light gradient, inverse
/// of TileComponent's raised gradient) so tiles read as sitting inside the
/// board rather than floating on a flat rectangle.
class SlotComponent extends PositionComponent {
  late final RRect _rrect;
  late final Gradient _gradient;

  SlotComponent({required Vector2 size, required Vector2 position}) : super(size: size, position: position, anchor: Anchor.topLeft) {
    final radius = Radius.circular(size.x * 0.16);
    _rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), radius);
    _gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x40000000), Color(0x22000000), Color(0x14FFFFFF)],
      stops: [0, 0.65, 1],
    );
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..shader = _gradient.createShader(Rect.fromLTWH(0, 0, size.x, size.y));
    canvas.drawRRect(_rrect, paint);
  }
}
