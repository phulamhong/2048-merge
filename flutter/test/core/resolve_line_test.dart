import 'package:farm_merge_flutter/core/resolve_line.dart';
import 'package:flutter_test/flutter_test.dart';

class _T {
  final int tier;
  const _T(this.tier);
}

bool _canMerge(_T a, _T b) => a.tier == b.tier && a.tier < 5;

List<int> _tiersOf(List<LineSlot<_T>> slots) => [
  for (final s in slots)
    switch (s) {
      SingleSlot<_T>(:final tile) => tile.tier,
      MergedSlot<_T>(:final a) => a.tier + 1,
    },
];

void main() {
  group('resolveLine', () {
    test('merges pairs once per move: [1,1,1,1] -> [2,2]', () {
      final line = [const _T(1), const _T(1), const _T(1), const _T(1)];
      expect(_tiersOf(resolveLine(line, _canMerge)), [2, 2]);
    });

    test('does not chain merges: [1,1,2] -> [2,2]', () {
      final line = [const _T(1), const _T(1), const _T(2), null];
      expect(_tiersOf(resolveLine(line, _canMerge)), [2, 2]);
    });

    test('compacts across gaps: [null,1,null,1] -> [2]', () {
      final line = [null, const _T(1), null, const _T(1)];
      expect(_tiersOf(resolveLine(line, _canMerge)), [2]);
    });

    test('merges the leading pair first: [2,2,2] -> [3,2]', () {
      final line = [const _T(2), const _T(2), const _T(2), null];
      expect(_tiersOf(resolveLine(line, _canMerge)), [3, 2]);
    });

    test('never merges the cap tier', () {
      final line = [const _T(5), const _T(5), null, null];
      expect(_tiersOf(resolveLine(line, _canMerge)), [5, 5]);
    });
  });
}
