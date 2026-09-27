import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../core/game_session.dart';
import 'tile_component.dart';

/// Renders the board for the current [GameSession] and keeps itself in sync
/// via [sync], called after every swipe/tap.
class GridComponent extends PositionComponent {
  static const cellSize = 76.0;
  static const spacing = 6.0;

  GameSession session;
  final _tiles = <int, TileComponent>{};
  final _slots = <RectangleComponent>[];

  GridComponent({required this.session}) : super(anchor: Anchor.topLeft) {
    _rebuildSlots();
    sync();
  }

  void setSession(GameSession newSession) {
    session = newSession;
    for (final t in _tiles.values) {
      t.removeFromParent();
    }
    _tiles.clear();
    for (final s in _slots) {
      s.removeFromParent();
    }
    _slots.clear();
    _rebuildSlots();
    sync();
  }

  void _rebuildSlots() {
    size = Vector2(
      session.level.cols * cellSize + (session.level.cols - 1) * spacing,
      session.level.rows * cellSize + (session.level.rows - 1) * spacing,
    );
    for (var row = 0; row < session.level.rows; row++) {
      for (var col = 0; col < session.level.cols; col++) {
        final slot = RectangleComponent(
          position: _cellPosition(row, col),
          size: Vector2.all(cellSize),
          anchor: Anchor.topLeft,
          paint: Paint()..color = const Color(0x33000000),
        );
        _slots.add(slot);
        add(slot);
      }
    }
  }

  Vector2 _cellPosition(int row, int col) =>
      Vector2(col * (cellSize + spacing), row * (cellSize + spacing));

  /// Reconciles the child TileComponents against session.board.tiles().
  void sync() {
    final liveUids = <int>{};
    for (final tile in session.board.tiles()) {
      liveUids.add(tile.uid);
      final existing = _tiles[tile.uid];
      final pos = _cellPosition(tile.row, tile.col);
      if (existing == null) {
        final comp = TileComponent(uid: tile.uid, tier: tile.tier, size: Vector2.all(cellSize), position: pos);
        _tiles[tile.uid] = comp;
        add(comp);
      } else {
        existing.position = pos;
        if (existing.tier != tile.tier) existing.updateTier(tile.tier);
      }
    }
    for (final uid in _tiles.keys.toList()) {
      if (!liveUids.contains(uid)) {
        _tiles[uid]!.removeFromParent();
        _tiles.remove(uid);
      }
    }
  }
}
