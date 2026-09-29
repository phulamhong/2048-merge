import 'package:flame/components.dart';

import '../core/game_session.dart';
import '../core/types.dart';
import 'obstacle_component.dart';
import 'slot_component.dart';
import 'tile_component.dart';
import 'tile_look.dart';

/// Renders the board for the current [GameSession]. [hardSync] snaps
/// everything to the session's current state with no animation (used for the
/// very first frame); [playEvents] replays one turn's [GameEvent]s as tweens
/// (slide → merge/split → harvest fly-away → spawn), matching the phased
/// playback in src/view/BoardView.ts so a swipe reads as movement instead of
/// tiles teleporting straight to the result.
class GridComponent extends PositionComponent {
  static const cellSize = 76.0;
  static const spacing = 6.0;

  GameSession session;
  final _tiles = <int, TileComponent>{};
  final _slots = <SlotComponent>[];
  final _obstacles = <Pos, ObstacleComponent>{};

  GridComponent({required this.session}) : super(anchor: Anchor.topLeft) {
    _rebuildSlots();
    hardSync();
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
    for (final o in _obstacles.values) {
      o.removeFromParent();
    }
    _obstacles.clear();
    _rebuildSlots();
    hardSync();
  }

  void _rebuildSlots() {
    size = Vector2(
      session.level.cols * cellSize + (session.level.cols - 1) * spacing,
      session.level.rows * cellSize + (session.level.rows - 1) * spacing,
    );
    for (var row = 0; row < session.level.rows; row++) {
      for (var col = 0; col < session.level.cols; col++) {
        final slot = SlotComponent(position: _cellPosition(row, col), size: Vector2.all(cellSize));
        _slots.add(slot);
        add(slot);
      }
    }
  }

  Vector2 _cellPosition(int row, int col) => Vector2(col * (cellSize + spacing), row * (cellSize + spacing));

  Look _lookFor(int tier, String? skinId) => lookOf(session.chain, tier, skinId);

  TileComponent _createTile(int uid, Look look, Vector2 pos) {
    final comp = TileComponent(uid: uid, look: look, size: Vector2.all(cellSize), position: pos);
    _tiles[uid] = comp;
    add(comp);
    return comp;
  }

  void _removeTile(int uid) {
    _tiles.remove(uid)?.removeFromParent();
  }

  /// Reconciles the child TileComponents against session.board.tiles() with
  /// no animation — used on first load and after a full board reset.
  void hardSync() {
    final liveUids = <int>{};
    for (final tile in session.board.tiles()) {
      liveUids.add(tile.uid);
      final existing = _tiles[tile.uid];
      final pos = _cellPosition(tile.row, tile.col);
      final look = _lookFor(tile.tier, tile.skinId);
      if (existing == null) {
        _createTile(tile.uid, look, pos);
      } else {
        existing.position = pos;
        if (existing.look.emoji != look.emoji || existing.look.color != look.color) {
          existing.updateLook(look);
        }
      }
    }
    for (final uid in _tiles.keys.toList()) {
      if (!liveUids.contains(uid)) _removeTile(uid);
    }

    final liveObstaclePos = <Pos>{};
    for (final entry in session.board.obstacles.entries) {
      liveObstaclePos.add(entry.key);
      final existing = _obstacles[entry.key];
      if (existing == null) {
        _createObstacle(entry.key, entry.value.heavy, entry.value.hits);
      } else {
        existing.updateState(heavy: entry.value.heavy, hits: entry.value.hits);
      }
    }
    for (final pos in _obstacles.keys.toList()) {
      if (!liveObstaclePos.contains(pos)) _removeObstacle(pos);
    }
  }

  ObstacleComponent _createObstacle(Pos pos, bool heavy, int hits) {
    final comp = ObstacleComponent(size: Vector2.all(cellSize), position: _cellPosition(pos.row, pos.col), heavy: heavy, hits: hits);
    _obstacles[pos] = comp;
    add(comp);
    return comp;
  }

  void _removeObstacle(Pos pos) {
    _obstacles.remove(pos)?.removeFromParent();
  }

  /// Replays one turn's events as tweens, in the same 4 phases as the web
  /// build: slide/converge, merge-pop/split/shake, harvest fly-away, spawn.
  /// [harvestTarget] maps a harvest event to where its tile should fly to
  /// (an objective icon for a matched harvest, the coin counter otherwise),
  /// in this component's local space (see [toLocal]).
  Future<void> playEvents(List<GameEvent> events, Vector2 Function(HarvestEvent e) harvestTarget) async {
    final movePhase = <Future<void>>[];
    for (final e in events) {
      if (e is MoveEvent) {
        final t = _tiles[e.uid];
        if (t != null) movePhase.add(t.moveTo(_cellPosition(e.to.row, e.to.col)));
      } else if (e is MergeEvent) {
        final dest = _cellPosition(e.result.row, e.result.col);
        final a = _tiles[e.a];
        final b = _tiles[e.b];
        if (a != null) movePhase.add(a.moveTo(dest));
        if (b != null) movePhase.add(b.moveTo(dest));
      }
    }
    await Future.wait(movePhase);

    final popPhase = <Future<void>>[];
    for (final e in events) {
      if (e is MergeEvent) {
        _removeTile(e.a);
        _removeTile(e.b);
        final comp = _createTile(e.result.uid, _lookFor(e.result.tier, e.result.skinId), _cellPosition(e.result.row, e.result.col));
        popPhase.add(comp.pop());
      } else if (e is SplitEvent) {
        popPhase.add(_playSplit(e));
      } else if (e is InvalidEvent) {
        final t = _tiles[e.uid];
        if (t != null) popPhase.add(t.shake());
      } else if (e is ObstacleHitEvent) {
        final o = _obstacles[e.pos];
        o?.updateState(heavy: false, hits: e.hits);
        if (o != null) popPhase.add(o.shake());
      } else if (e is ObstacleClearEvent) {
        final o = _obstacles.remove(e.pos);
        if (o != null) popPhase.add(o.clearOut().then((_) => o.removeFromParent()));
      }
    }
    await Future.wait(popPhase);

    final flyPhase = <Future<void>>[];
    for (final e in events) {
      if (e is HarvestEvent) {
        final t = _tiles.remove(e.tile.uid);
        if (t != null) flyPhase.add(t.flyTo(harvestTarget(e)).then((_) => t.removeFromParent()));
      }
    }
    await Future.wait(flyPhase);

    final spawnPhase = <Future<void>>[];
    for (final e in events) {
      if (e is SpawnEvent) {
        final comp = _createTile(e.tile.uid, _lookFor(e.tile.tier, e.tile.skinId), _cellPosition(e.tile.row, e.tile.col));
        spawnPhase.add(comp.spawnIn());
      } else if (e is ObstacleSpawnEvent) {
        final comp = _createObstacle(e.pos, false, 0);
        spawnPhase.add(comp.spawnIn());
      } else if (e is ObstacleEscalateEvent) {
        _removeObstacle(e.clearedA);
        _removeObstacle(e.clearedB);
        final comp = _createObstacle(e.heavyPos, true, 0);
        spawnPhase.add(comp.spawnIn());
      }
    }
    await Future.wait(spawnPhase);
  }

  Future<void> _playSplit(SplitEvent e) async {
    final keptComp = _tiles[e.kept.uid];
    keptComp?.updateLook(_lookFor(e.kept.tier, e.kept.skinId));
    final startPos = keptComp?.position.clone() ?? _cellPosition(e.kept.row, e.kept.col);
    final child = _createTile(e.spawned.uid, _lookFor(e.spawned.tier, e.spawned.skinId), startPos.clone());
    child.scale = Vector2.all(0.6);
    final endPos = _cellPosition(e.spawned.row, e.spawned.col);
    await Future.wait([if (keptComp != null) keptComp.pop() else Future.value(), child.growTo(endPos)]);
  }
}
