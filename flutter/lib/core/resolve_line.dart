/// Ported from src/core/resolveLine.ts. Compacts one line toward index 0
/// using 2048 rules. Each pair merges at most once per move because a merged
/// pair is consumed together (no chain merges).
library;

sealed class LineSlot<T> {
  const LineSlot();
}

class SingleSlot<T> extends LineSlot<T> {
  final T tile;
  const SingleSlot(this.tile);
}

class MergedSlot<T> extends LineSlot<T> {
  final T a;
  final T b;
  const MergedSlot(this.a, this.b);
}

List<LineSlot<T>> resolveLine<T>(List<T?> line, bool Function(T, T) canMerge) {
  final tiles = line.whereType<T>().toList();
  final slots = <LineSlot<T>>[];
  var i = 0;
  while (i < tiles.length) {
    final a = tiles[i];
    final hasNext = i + 1 < tiles.length;
    final b = hasNext ? tiles[i + 1] : null;
    if (hasNext && canMerge(a, b as T)) {
      slots.add(MergedSlot(a, b));
      i += 2;
    } else {
      slots.add(SingleSlot(a));
      i += 1;
    }
  }
  return slots;
}
