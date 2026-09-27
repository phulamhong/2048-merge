import 'package:farm_merge_flutter/core/game_session.dart';
import 'package:farm_merge_flutter/core/types.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('swipe', () {
    test('slides and merges in each direction like 2048', () {
      final s = sessionWith([
        [1, 1, 0, 1],
        [0, 0, 0, 0],
      ]);
      s.swipe(Direction.left);
      expect(tiersGrid(s), [
        [2, 1, 0, 0],
        [0, 0, 0, 0],
      ]);
      s.swipe(Direction.right);
      expect(tiersGrid(s)[0], [0, 0, 2, 1]);
      s.swipe(Direction.down);
      expect(tiersGrid(s)[1], [0, 0, 2, 1]);
      s.swipe(Direction.up);
      expect(tiersGrid(s)[0], [0, 0, 2, 1]);
    });

    test('does not cost a move or spawn when nothing changes', () {
      final s = sessionWith(
        [
          [1, 2, 0, 0],
        ],
        spawn: const SpawnConfig(perTurn: 1),
      );
      final events = s.swipe(Direction.left);
      expect(events, [isA<NoChangeEvent>()]);
      expect(s.movesUsed, 0);
      expect(s.board.tiles().length, 2);
    });

    test('spawns tier-1 tiles after a changing swipe', () {
      final s = sessionWith(
        [
          [0, 0, 0, 1],
        ],
        spawn: const SpawnConfig(perTurn: 1),
      );
      final events = s.swipe(Direction.left);
      expect(events.whereType<SpawnEvent>().length, 1);
      expect(s.movesUsed, 1);
    });

    test('auto-harvests over-merged tiles into coins in merge mode', () {
      final s = sessionWith(
        [
          [3, 3, 0, 0],
        ],
        objectives: const [ObjectiveDef(tier: 2, target: 1)],
      );
      final events = s.swipe(Direction.left);
      expect(events.whereType<HarvestEvent>().any((e) => e.auto), true);
      expect(s.board.tiles(), isEmpty);
      expect(s.coins, greaterThan(0));
    });

    test('keeps over-merged tiles in split mode so they can be split again', () {
      final s = sessionWith(
        [
          [3, 3, 0, 0],
        ],
        mode: LevelMode.split,
        objectives: const [ObjectiveDef(tier: 1, target: 1)],
      );
      s.swipe(Direction.left);
      expect(tiersGrid(s)[0], [4, 0, 0, 0]);
    });
  });

  group('tap', () {
    test('harvests a needed tile without spending a move and wins', () {
      final s = sessionWith([
        [3, 0, 0, 0],
      ]);
      final events = s.tap(0, 0);
      final e = events[0] as HarvestEvent;
      expect(e.auto, false);
      expect(e.objectiveIndex, 0);
      expect(s.movesUsed, 0);
      expect(s.status, SessionStatus.won);
    });

    test('rejects taps on unneeded tiles in merge mode', () {
      final s = sessionWith([
        [2, 0, 0, 0],
      ]);
      final events = s.tap(0, 0);
      expect(events.length, 1);
      final e = events[0] as InvalidEvent;
      expect(e.reason, InvalidReason.notNeeded);
    });

    test('splits into two lower tiles, preferring the right neighbour', () {
      final s = sessionWith(
        [
          [4, 0],
          [0, 0],
        ],
        mode: LevelMode.split,
        objectives: const [ObjectiveDef(tier: 1, target: 4)],
      );
      s.tap(0, 0);
      expect(tiersGrid(s), [
        [3, 3],
        [0, 0],
      ]);
      expect(s.movesUsed, 1);
    });

    test('falls back to other neighbours, and refuses when boxed in', () {
      final s = sessionWith(
        [
          [1, 4],
          [0, 1],
        ],
        mode: LevelMode.split,
        objectives: const [ObjectiveDef(tier: 1, target: 9)],
      );
      final boxed = s.tap(0, 1)[0] as InvalidEvent;
      expect(boxed.reason, InvalidReason.noSpace);

      final t = sessionWith(
        [
          [1, 4],
          [1, 0],
        ],
        mode: LevelMode.split,
        objectives: const [ObjectiveDef(tier: 2, target: 9)],
      );
      t.tap(0, 1);
      expect(tiersGrid(t), [
        [1, 3],
        [1, 3],
      ]);
    });

    test('harvest takes priority over split', () {
      final s = sessionWith(
        [
          [2, 0, 0, 0],
        ],
        mode: LevelMode.mixed,
        objectives: const [ObjectiveDef(tier: 2, target: 1)],
      );
      expect(s.tap(0, 0)[0], isA<HarvestEvent>());
    });

    test('matches skin-specific objectives only with the right skin', () {
      final skinned = ChainDef(
        id: testChain.id,
        name: testChain.name,
        tiers: [
          for (final t in testChain.tiers)
            if (t.tier == 4)
              TierDef(
                tier: t.tier,
                id: t.id,
                name: t.name,
                emoji: t.emoji,
                color: t.color,
                skins: const [SkinDef(id: 'apple', name: 'A', emoji: '', color: 0, weight: 1)],
              )
            else
              t,
        ],
      );
      final s = GameSession(
        makeLevel(
          initialTiles: [const InitialTile(tier: 4, row: 0, col: 0)],
          objectives: const [ObjectiveDef(tier: 4, skinId: 'apple', target: 1)],
        ),
        skinned,
        seed: 1,
      );
      expect(s.board.get(0, 0)?.skinId, 'apple');
      expect(s.tap(0, 0)[0], isA<HarvestEvent>());
    });
  });

  group('lose conditions', () {
    test('loses when the board is full with no merges', () {
      final s = sessionWith(
        [
          [2, 1],
          [3, 0],
        ],
        spawn: const SpawnConfig(perTurn: 1),
        objectives: const [ObjectiveDef(tier: 4, target: 1)],
      );
      s.swipe(Direction.right);
      // the only empty cell (1,0) gets a tier-1 spawn: [[2,1],[1,3]] has no merges
      expect(tiersGrid(s), [
        [2, 1],
        [1, 3],
      ]);
      expect(s.status, SessionStatus.lost);
      expect(s.loseReason, LoseReason.stuck);
    });

    test('loses when moves run out', () {
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
    });

    test('still allows harvesting a needed tile at zero moves', () {
      final s = sessionWith(
        [
          [1, 1, 0, 0],
        ],
        moveLimit: 1,
        objectives: const [ObjectiveDef(tier: 2, target: 1)],
      );
      s.swipe(Direction.left);
      expect(s.status, SessionStatus.playing);
      s.tap(0, 0);
      expect(s.status, SessionStatus.won);
    });
  });

  group('stars', () {
    test('awards 3/2/1 stars by fraction of moves left', () {
      expect(starsFor(3, 10), 3);
      expect(starsFor(2, 10), 2);
      expect(starsFor(1, 10), 1);
    });
  });

  group('clone', () {
    test('is independent from the original', () {
      final s = sessionWith([
        [1, 1, 0, 0],
      ]);
      final c = s.clone();
      c.swipe(Direction.left);
      expect(tiersGrid(s)[0], [1, 1, 0, 0]);
      expect(tiersGrid(c)[0], [2, 0, 0, 0]);
    });
  });
}
