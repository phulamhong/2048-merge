import 'resolve_line.dart';
import 'rng.dart';
import 'types.dart';

class MoveInfo {
  final int uid;
  final Pos to;
  const MoveInfo({required this.uid, required this.to});
}

class MergeInfo {
  final int a;
  final int b;
  final Tile result;
  const MergeInfo({required this.a, required this.b, required this.result});
}

class SlideResult {
  final List<MoveInfo> moves;
  final List<MergeInfo> merges;
  const SlideResult({required this.moves, required this.merges});
  bool get changed => moves.isNotEmpty || merges.isNotEmpty;
}

class SplitResult {
  final Tile kept;
  final Tile spawned;
  const SplitResult({required this.kept, required this.spawned});
}

const _splitDirections = [Pos(0, 1), Pos(1, 0), Pos(0, -1), Pos(-1, 0)];

/// Ported from src/core/Board.ts.
class Board {
  final int rows;
  final int cols;
  final ChainDef chain;
  final Rng rng;
  late final List<List<Tile?>> _cells;
  final Map<Pos, ObstacleCell> obstacles = {};
  int _nextUid = 1;

  Board(this.rows, this.cols, this.chain, this.rng) {
    _cells = List.generate(rows, (_) => List<Tile?>.filled(cols, null));
  }

  int get maxTier => chain.tiers.length;

  Tile? get(int row, int col) => _inBounds(row, col) ? _cells[row][col] : null;

  List<Tile> tiles() => _cells.expand((row) => row).whereType<Tile>().toList();

  List<Pos> emptyCells() {
    final out = <Pos>[];
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        if (_cells[row][col] == null && !obstacles.containsKey(Pos(row, col))) out.add(Pos(row, col));
      }
    }
    return out;
  }

  Tile createTile(int tier, Pos pos, BornFrom bornFrom) {
    final tile = Tile(uid: _nextUid++, tier: tier, row: pos.row, col: pos.col, bornFrom: bornFrom);
    final skinId = _rollSkin(tier);
    if (skinId != null) tile.skinId = skinId;
    _cells[pos.row][pos.col] = tile;
    return tile;
  }

  void remove(Tile tile) {
    if (identical(_cells[tile.row][tile.col], tile)) _cells[tile.row][tile.col] = null;
  }

  Tile? spawnRandom(int tier, [BornFrom bornFrom = BornFrom.spawn]) {
    final empty = emptyCells();
    if (empty.isEmpty) return null;
    return createTile(tier, rng.pick(empty), bornFrom);
  }

  bool canMerge(Tile a, Tile b) => a.tier == b.tier && a.tier < maxTier;

  SlideResult slide(Direction dir) {
    final moves = <MoveInfo>[];
    final merges = <MergeInfo>[];
    for (final line in _linesFor(dir)) {
      for (final segment in _segmentsAround(line)) {
        _slideSegment(segment, moves, merges);
      }
    }
    return SlideResult(moves: moves, merges: merges);
  }

  void _slideSegment(List<Pos> segment, List<MoveInfo> moves, List<MergeInfo> merges) {
    final lineTiles = [for (final p in segment) _cells[p.row][p.col]];
    final slots = resolveLine<Tile>(lineTiles, canMerge);

    for (final p in segment) {
      _cells[p.row][p.col] = null;
    }

    for (var idx = 0; idx < slots.length; idx++) {
      final to = segment[idx];
      final slot = slots[idx];
      switch (slot) {
        case SingleSlot<Tile>(:final tile):
          if (tile.row != to.row || tile.col != to.col) {
            moves.add(MoveInfo(uid: tile.uid, to: to));
          }
          tile.row = to.row;
          tile.col = to.col;
          _cells[to.row][to.col] = tile;
        case MergedSlot<Tile>(:final a, :final b):
          final result = createTile(a.tier + 1, to, BornFrom.merge);
          merges.add(MergeInfo(a: a.uid, b: b.uid, result: result));
      }
    }
  }

  /// Splits one full line into the sub-segments tiles actually compact
  /// within — an obstacle cell is a fixed wall a slide cannot cross, so each
  /// maximal run of non-obstacle positions between walls (or edges) is its
  /// own segment. A line with no obstacles is exactly one segment, matching
  /// the pre-obstacle behaviour.
  List<List<Pos>> _segmentsAround(List<Pos> line) {
    if (obstacles.isEmpty) return [line];
    final segments = <List<Pos>>[];
    var current = <Pos>[];
    for (final p in line) {
      if (obstacles.containsKey(p)) {
        if (current.isNotEmpty) segments.add(current);
        current = [];
      } else {
        current.add(p);
      }
    }
    if (current.isNotEmpty) segments.add(current);
    return segments;
  }

  /// Free neighbour a split would use (right, down, left, up), or null.
  Pos? splitTarget(Tile tile) {
    for (final d in _splitDirections) {
      final row = tile.row + d.row;
      final col = tile.col + d.col;
      final pos = Pos(row, col);
      if (_inBounds(row, col) && _cells[row][col] == null && !obstacles.containsKey(pos)) return pos;
    }
    return null;
  }

  SplitResult? split(Tile tile) {
    if (tile.tier <= 1) return null;
    final target = splitTarget(tile);
    if (target == null) return null;

    final newTier = tile.tier - 1;
    tile.tier = newTier;
    tile.bornFrom = BornFrom.split;
    final skinId = _rollSkin(newTier);
    tile.skinId = skinId;
    final spawned = createTile(newTier, target, BornFrom.split);
    return SplitResult(kept: tile, spawned: spawned);
  }

  bool hasAdjacentMerge() {
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final t = _cells[row][col];
        if (t == null) continue;
        final right = get(row, col + 1);
        final down = get(row + 1, col);
        if ((right != null && canMerge(t, right)) || (down != null && canMerge(t, down))) return true;
      }
    }
    return false;
  }

  /// Booster: scramble every tile to a random cell, keeping the same set of
  /// tiles (tier/skin/uid unchanged) — just new positions.
  void shuffle() {
    final existing = tiles().toList();
    if (existing.isEmpty) return;
    final positions = [for (var r = 0; r < rows; r++) for (var c = 0; c < cols; c++) Pos(r, c)];
    for (var i = positions.length - 1; i > 0; i--) {
      final j = rng.intBelow(i + 1);
      final tmp = positions[i];
      positions[i] = positions[j];
      positions[j] = tmp;
    }
    for (final t in existing) {
      _cells[t.row][t.col] = null;
    }
    for (var i = 0; i < existing.length; i++) {
      final t = existing[i];
      final p = positions[i];
      t.row = p.row;
      t.col = p.col;
      _cells[p.row][p.col] = t;
    }
  }

  Board clone(Rng rng) {
    final copy = Board(rows, cols, chain, rng);
    copy._nextUid = _nextUid;
    for (final t in tiles()) {
      copy._cells[t.row][t.col] = t.copy();
    }
    for (final entry in obstacles.entries) {
      copy.obstacles[entry.key] = ObstacleCell(hits: entry.value.hits, heavy: entry.value.heavy);
    }
    return copy;
  }

  /// Places a new light (not-yet-escalated) obstacle at [pos]. [pos] must be
  /// empty and not already an obstacle — callers (GameSession) pick it from
  /// [emptyCells].
  void spawnObstacle(Pos pos) {
    obstacles[pos] = ObstacleCell();
  }

  /// Registers 1 swipe-hit on the obstacle at [pos]. Returns true if that hit
  /// cleared it (reached [decayHitsToClear] — already removed from
  /// [obstacles] when this returns true). No-op (returns false) if there's no
  /// obstacle there or it's already heavy (heavy obstacles only clear via
  /// [repair]).
  bool hitObstacle(Pos pos) {
    final cell = obstacles[pos];
    if (cell == null || cell.heavy) return false;
    cell.hits++;
    if (cell.hits >= decayHitsToClear) {
      obstacles.remove(pos);
      return true;
    }
    return false;
  }

  /// Removes the 2 given light obstacles and places 1 heavy obstacle at
  /// [heavyPos] (one of the 2 — GameSession picks which).
  void escalate(Pos a, Pos b, Pos heavyPos) {
    obstacles.remove(a);
    obstacles.remove(b);
    obstacles[heavyPos] = ObstacleCell(heavy: true);
  }

  /// Clears a heavy obstacle unconditionally (the "Bộ Sửa Chữa" booster).
  /// No-op if [pos] isn't a heavy obstacle.
  void repair(Pos pos) {
    final cell = obstacles[pos];
    if (cell != null && cell.heavy) obstacles.remove(pos);
  }

  String? _rollSkin(int tier) {
    final skins = chain.tiers[tier - 1].skins;
    if (skins == null || skins.isEmpty) return null;
    return rng.weighted(skins, (s) => s.weight).id;
  }

  bool _inBounds(int row, int col) => row >= 0 && row < rows && col >= 0 && col < cols;

  /// Lines of cell positions, each ordered from the edge tiles slide toward.
  List<List<Pos>> _linesFor(Direction dir) {
    final lines = <List<Pos>>[];
    if (dir == Direction.left || dir == Direction.right) {
      for (var row = 0; row < rows; row++) {
        final line = [for (var col = 0; col < cols; col++) Pos(row, col)];
        lines.add(dir == Direction.right ? line.reversed.toList() : line);
      }
    } else {
      for (var col = 0; col < cols; col++) {
        final line = [for (var row = 0; row < rows; row++) Pos(row, col)];
        lines.add(dir == Direction.down ? line.reversed.toList() : line);
      }
    }
    return lines;
  }
}
