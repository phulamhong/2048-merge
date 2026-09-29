import 'package:farm_merge_flutter/core/types.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('obstacles (Hư hao)', () {
    test('Board.hitObstacle clears a light obstacle after decayHitsToClear hits, never a heavy one', () {
      final s = sessionWith([
        [0],
      ]);
      const pos = Pos(0, 0);
      s.board.spawnObstacle(pos);
      for (var i = 0; i < decayHitsToClear - 1; i++) {
        expect(s.board.hitObstacle(pos), false);
      }
      expect(s.board.obstacles[pos]!.hits, decayHitsToClear - 1);
      expect(s.board.hitObstacle(pos), true);
      expect(s.board.obstacles.containsKey(pos), false);

      s.board.obstacles[pos] = ObstacleCell(heavy: true);
      expect(s.board.hitObstacle(pos), false);
      expect(s.board.obstacles[pos]!.heavy, true);
    });

    test('slide stops at an obstacle instead of sliding through it, and hits it once on arrival', () {
      // 1 row, tile at col 0, obstacle at col 2 — swiping right can only push
      // the tile as far as col 1 (col 2 is a wall), not past it to col 3.
      final s = sessionWith([
        [1, 0, 0, 0],
      ]);
      s.board.spawnObstacle(const Pos(0, 2));

      s.swipe(Direction.right);
      expect(tiersGrid(s), [
        [0, 1, 0, 0],
      ]);
      expect(s.board.obstacles[const Pos(0, 2)]!.hits, 1);

      // Swiping right again is a no-op (the tile is already against the
      // wall) — it must not cost a move or count a second hit.
      final events = s.swipe(Direction.right);
      expect(events, [isA<NoChangeEvent>()]);
      expect(s.board.obstacles[const Pos(0, 2)]!.hits, 1);
    });

    test('decay tick spawns a new light obstacle once under the cap', () {
      final s = sessionWith(
        [
          [1, 0, 0],
        ],
        decaySpawn: const DecaySpawnConfig(everyTurns: 1, max: 5),
      );
      expect(s.board.obstacles, isEmpty);
      s.swipe(Direction.right);
      expect(s.board.obstacles.length, 1);
      expect(s.board.obstacles.values.first.heavy, false);
    });

    test('decay tick escalates 2 light obstacles into 1 heavy one once at the cap', () {
      final s = sessionWith(
        [
          [1, 0, 0, 0],
        ],
        decaySpawn: const DecaySpawnConfig(everyTurns: 1, max: 2),
      );
      s.board.spawnObstacle(const Pos(0, 2));
      s.board.spawnObstacle(const Pos(0, 3));

      s.swipe(Direction.right); // already at the cap (2) -> escalates instead of spawning a 3rd.

      expect(s.board.obstacles.length, 1);
      expect(s.board.obstacles.values.first.heavy, true);
    });

    test('repairAnyHeavy clears a heavy obstacle but leaves light ones alone', () {
      final s = sessionWith([
        [0, 0],
      ]);
      s.board.spawnObstacle(const Pos(0, 0));
      s.board.obstacles[const Pos(0, 1)] = ObstacleCell(heavy: true);

      expect(s.repairAnyHeavy(), true);
      expect(s.board.obstacles.containsKey(const Pos(0, 1)), false);
      expect(s.board.obstacles.containsKey(const Pos(0, 0)), true);
      expect(s.hasHeavyObstacle, false);

      expect(s.repairAnyHeavy(), false); // nothing heavy left
    });
  });
}
