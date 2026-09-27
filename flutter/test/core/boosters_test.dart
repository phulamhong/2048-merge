import 'package:farm_merge_flutter/core/types.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('bonus moves booster', () {
    test('extends movesLeft and revives a session lost to outOfMoves', () {
      final s = sessionWith(
        [
          [1, 0, 0, 0],
        ],
        moveLimit: 1,
        objectives: const [ObjectiveDef(tier: 4, target: 1)],
      );
      s.swipe(Direction.right);
      expect(s.status, SessionStatus.lost);
      expect(s.loseReason, LoseReason.outOfMoves);

      s.addBonusMoves(5);
      expect(s.status, SessionStatus.playing);
      expect(s.movesLeft, 5);
    });

    test('does not revive a session lost to being stuck', () {
      final s = sessionWith(
        [
          [2, 1],
          [3, 0],
        ],
        spawn: const SpawnConfig(perTurn: 1),
        objectives: const [ObjectiveDef(tier: 4, target: 1)],
      );
      s.swipe(Direction.right);
      expect(s.status, SessionStatus.lost);
      expect(s.loseReason, LoseReason.stuck);

      s.addBonusMoves(5);
      expect(s.status, SessionStatus.lost);
    });
  });

  group('shuffle booster', () {
    test('keeps the same multiset of tiers, changes at least one position over many tries', () {
      final s = sessionWith([
        [1, 2, 3, 4],
      ]);
      List<int> tierMultiset() => tiersGrid(s).expand((r) => r).where((t) => t > 0).toList()..sort();
      final before = tierMultiset();

      var moved = false;
      for (var i = 0; i < 20 && !moved; i++) {
        final beforeGrid = tiersGrid(s);
        s.shuffleBoard();
        moved = tiersGrid(s).toString() != beforeGrid.toString();
      }

      expect(moved, true, reason: 'shuffle should move at least one tile within 20 tries');
      expect(tierMultiset(), before);
    });

    test('is a no-op when the session is not playing', () {
      final s = sessionWith([
        [3, 0, 0, 0],
      ]);
      s.tap(0, 0);
      expect(s.status, SessionStatus.won);
      final before = tiersGrid(s);
      s.shuffleBoard();
      expect(tiersGrid(s), before);
    });
  });

  group('undo booster', () {
    test('canUndo is false before any move and true after one', () {
      final s = sessionWith([
        [1, 1, 0, 0],
      ]);
      expect(s.canUndo, false);
      s.swipe(Direction.left);
      expect(s.canUndo, true);
    });

    test('previousSnapshot restores the pre-swipe board and move count', () {
      final s = sessionWith([
        [1, 1, 0, 0],
      ]);
      s.swipe(Direction.left);
      expect(tiersGrid(s)[0], [2, 0, 0, 0]);
      expect(s.movesUsed, 1);

      final restored = s.previousSnapshot!;
      expect(tiersGrid(restored)[0], [1, 1, 0, 0]);
      expect(restored.movesUsed, 0);
    });

    test('a no-op swipe does not overwrite an existing snapshot', () {
      final s = sessionWith(
        [
          [1, 1, 0, 0],
        ],
        spawn: const SpawnConfig(perTurn: 0),
      );
      s.swipe(Direction.left); // real move: [2,0,0,0]
      final snapshotAfterRealMove = s.previousSnapshot;
      s.swipe(Direction.left); // no-op: already flush left
      expect(s.previousSnapshot, same(snapshotAfterRealMove));
    });

    test('harvest is undoable too', () {
      final s = sessionWith([
        [3, 0, 0, 0],
      ]);
      expect(s.canUndo, false);
      s.tap(0, 0);
      expect(s.status, SessionStatus.won);
      expect(s.canUndo, true);
      expect(s.previousSnapshot!.status, SessionStatus.playing);
    });
  });
}
