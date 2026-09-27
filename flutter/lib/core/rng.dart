/// Ported from src/core/rng.ts — same mulberry32 PRNG, bit for bit, so seeded
/// sequences (and therefore level difficulty tuning) match the TS version.
class Rng {
  int _state;
  Rng(int seed) : _state = seed & 0xFFFFFFFF;

  double next() {
    _state = (_state + 0x6d2b79f5) & 0xFFFFFFFF;
    int t = _state;
    t = _imul(t ^ (t >>> 15), t | 1) & 0xFFFFFFFF;
    final addend = (t + _imul(t ^ (t >>> 7), t | 61)) & 0xFFFFFFFF;
    t = (t ^ addend) & 0xFFFFFFFF;
    return ((t ^ (t >>> 14)) & 0xFFFFFFFF) / 4294967296;
  }

  int intBelow(int maxExclusive) => (next() * maxExclusive).floor();

  T pick<T>(List<T> items) => items[intBelow(items.length)];

  T weighted<T>(List<T> items, num Function(T) weightOf) {
    final total = items.fold<num>(0, (s, i) => s + weightOf(i));
    var roll = next() * total;
    for (final item in items) {
      roll -= weightOf(item);
      if (roll < 0) return item;
    }
    return items.last;
  }

  Rng clone() => Rng(_state);

  static int _imul(int a, int b) {
    final result = (a & 0xFFFFFFFF) * (b & 0xFFFFFFFF);
    return result & 0xFFFFFFFF;
  }
}
