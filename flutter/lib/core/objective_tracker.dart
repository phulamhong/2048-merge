import 'types.dart';

/// Ported from src/core/ObjectiveTracker.ts.
class ObjectiveTracker {
  final List<ObjectiveDef> objectives;
  final List<int> progress;

  ObjectiveTracker(this.objectives, [List<int>? progress]) : progress = progress != null ? [...progress] : List.filled(objectives.length, 0);

  /// Index of the first unfinished objective this tile satisfies, or null.
  int? match(Tile tile) {
    for (var i = 0; i < objectives.length; i++) {
      final o = objectives[i];
      final skinOk = o.skinId == null || o.skinId == tile.skinId;
      if (progress[i] < o.target && o.tier == tile.tier && skinOk) return i;
    }
    return null;
  }

  void add(int index) {
    progress[index]++;
  }

  /// Highest tier still needed by an unfinished objective (0 when all done).
  int maxActiveTier() {
    var m = 0;
    for (var i = 0; i < objectives.length; i++) {
      if (progress[i] < objectives[i].target) m = m > objectives[i].tier ? m : objectives[i].tier;
    }
    return m;
  }

  bool isComplete() {
    for (var i = 0; i < objectives.length; i++) {
      if (progress[i] < objectives[i].target) return false;
    }
    return true;
  }

  ObjectiveTracker clone() => ObjectiveTracker(objectives, progress);
}
