import 'board.dart';
import 'objective_tracker.dart';
import 'rng.dart';
import 'types.dart';

const overflowCoinsPerTier = 5;
const (double, double) _defaultStarThresholds = (0.15, 0.3);

int starsFor(int movesLeft, int moveLimit, [(double, double)? thresholds]) {
  final t = thresholds ?? _defaultStarThresholds;
  final ratio = movesLeft / moveLimit;
  if (ratio >= t.$2) return 3;
  if (ratio >= t.$1) return 2;
  return 1;
}

/// One play-through of a level. Pure game rules, no rendering: every action
/// mutates the model immediately and returns the events the view should replay.
/// Ported from src/core/GameSession.ts.
class GameSession {
  final LevelConfig level;
  final ChainDef chain;
  late final Board board;
  late final ObjectiveTracker tracker;
  int movesUsed = 0;
  int coins = 0;
  SessionStatus status = SessionStatus.playing;
  LoseReason? loseReason;
  late final Rng _rng;

  GameSession(this.level, this.chain, {int? seed}) {
    _rng = Rng(seed ?? DateTime.now().millisecondsSinceEpoch);
    board = Board(level.rows, level.cols, chain, _rng);
    tracker = ObjectiveTracker(level.objectives);
    for (final t in level.initialTiles ?? const <InitialTile>[]) {
      if (t.row != null && t.col != null) {
        board.createTile(t.tier, Pos(t.row!, t.col!), BornFrom.initial);
      } else {
        board.spawnRandom(t.tier, BornFrom.initial);
      }
    }
    final initialRandom = level.initialRandom ?? (level.mode == LevelMode.split ? 0 : 2);
    for (var i = 0; i < initialRandom; i++) {
      board.spawnRandom(1, BornFrom.initial);
    }
  }

  GameSession._empty(this.level, this.chain);

  int get movesLeft {
    final left = level.moveLimit - movesUsed;
    return left < 0 ? 0 : left;
  }

  int get stars => starsFor(movesLeft, level.moveLimit, level.starThresholds);

  bool get canSplit => level.mode != LevelMode.merge;

  bool isHarvestable(Tile tile) => tracker.match(tile) != null;

  List<GameEvent> swipe(Direction dir) {
    if (status != SessionStatus.playing || movesLeft <= 0) return const [];
    final res = board.slide(dir);
    if (!res.changed) return const [NoChangeEvent()];

    final events = <GameEvent>[];
    for (final m in res.moves) {
      events.add(MoveEvent(uid: m.uid, to: m.to));
    }
    for (final m in res.merges) {
      events.add(MergeEvent(a: m.a, b: m.b, result: m.result.copy()));
    }
    movesUsed++;

    for (final m in res.merges) {
      _autoHarvestIfOverflow(m.result, events);
    }
    if (_checkWin()) return events;

    final doubleChance = level.spawn.doubleChance;
    final extra = (doubleChance != null && _rng.next() < doubleChance) ? 1 : 0;
    for (var i = 0; i < level.spawn.perTurn + extra; i++) {
      _spawn(1, events);
    }
    _periodicSpawn(events);
    _checkLose();
    return events;
  }

  /// Tap priority: harvest (free) -> split (1 move) -> invalid.
  List<GameEvent> tap(int row, int col) {
    if (status != SessionStatus.playing) return const [];
    final tile = board.get(row, col);
    if (tile == null) return const [];

    final idx = tracker.match(tile);
    if (idx != null) {
      board.remove(tile);
      tracker.add(idx);
      final events = <GameEvent>[HarvestEvent(tile: tile.copy(), auto: false, objectiveIndex: idx, coins: 0)];
      if (!_checkWin()) _checkLose();
      return events;
    }

    if (!canSplit) return [InvalidEvent(uid: tile.uid, reason: InvalidReason.notNeeded)];
    if (tile.tier <= 1) return [InvalidEvent(uid: tile.uid, reason: InvalidReason.tier1)];
    if (movesLeft <= 0) return const [];
    final res = board.split(tile);
    if (res == null) return [InvalidEvent(uid: tile.uid, reason: InvalidReason.noSpace)];

    final events = <GameEvent>[SplitEvent(kept: res.kept.copy(), spawned: res.spawned.copy())];
    movesUsed++;
    _periodicSpawn(events);
    _checkLose();
    return events;
  }

  GameSession clone() {
    final rng = _rng.clone();
    final copy = GameSession._empty(level, chain)
      .._rng = rng
      ..board = board.clone(rng)
      ..tracker = tracker.clone()
      ..movesUsed = movesUsed
      ..coins = coins
      ..status = status
      ..loseReason = loseReason;
    return copy;
  }

  /// Merge levels only: a freshly merged tile no unfinished objective accepts
  /// and that can never grow into a needed tier is cashed in, so it cannot
  /// clog the board.
  void _autoHarvestIfOverflow(Tile tile, List<GameEvent> events) {
    if (level.mode != LevelMode.merge) return;
    final maxActive = tracker.maxActiveTier();
    if (tracker.match(tile) != null || tile.tier < maxActive) return;
    board.remove(tile);
    final coinsEarned = tile.tier * overflowCoinsPerTier;
    coins += coinsEarned;
    events.add(HarvestEvent(tile: tile.copy(), auto: true, objectiveIndex: null, coins: coinsEarned));
  }

  void _spawn(int tier, List<GameEvent> events) {
    final tile = board.spawnRandom(tier);
    if (tile != null) events.add(SpawnEvent(tile: tile.copy()));
  }

  void _periodicSpawn(List<GameEvent> events) {
    final every = level.spawn.bigTileEvery;
    if (every != null && movesUsed % every.turns == 0) _spawn(every.tier, events);
  }

  bool _checkWin() {
    if (!tracker.isComplete()) return false;
    status = SessionStatus.won;
    return true;
  }

  void _checkLose() {
    final tiles = board.tiles();
    final anyHarvestable = tiles.any(isHarvestable);
    // With at least one tile and one empty cell, some swipe (and any split) is possible.
    final boardLocked = tiles.isEmpty || board.emptyCells().isEmpty;
    if (movesLeft <= 0 && !anyHarvestable) {
      status = SessionStatus.lost;
      loseReason = LoseReason.outOfMoves;
    } else if (boardLocked && !board.hasAdjacentMerge() && !anyHarvestable) {
      status = SessionStatus.lost;
      loseReason = LoseReason.stuck;
    }
  }
}
