import 'package:farm_merge_flutter/data/chains.dart';
import 'package:farm_merge_flutter/data/chapters.dart';
import 'package:farm_merge_flutter/data/levels.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('content data', () {
    for (final level in levelList) {
      test('level ${level.id} is consistent', () {
        final chain = chains[level.chainId];
        expect(chain, isNotNull, reason: 'chain ${level.chainId}');
        for (final o in level.objectives) {
          expect(o.tier, greaterThanOrEqualTo(1));
          expect(o.tier, lessThanOrEqualTo(chain!.tiers.length));
          if (o.skinId != null) {
            expect(chain.tiers[o.tier - 1].skins?.map((s) => s.id), contains(o.skinId));
          }
        }
        final seen = <String>{};
        for (final t in level.initialTiles ?? const []) {
          expect(t.tier, lessThanOrEqualTo(chain!.tiers.length));
          if (t.row == null || t.col == null) continue;
          expect(t.row!, lessThan(level.rows));
          expect(t.col!, lessThan(level.cols));
          final key = '${t.row},${t.col}';
          expect(seen.contains(key), false);
          seen.add(key);
        }
        expect(level.moveLimit, greaterThan(0));
      });
    }

    for (final chapter in chapters) {
      test('chapter ${chapter.id} recipe is producible', () {
        final produced = <String>[];
        for (final id in chapter.levelIds) {
          expect(levels[id], isNotNull, reason: 'level $id');
          produced.add(levels[id]!.producesIngredient);
        }
        for (final ing in chapter.recipe.ingredients) {
          expect(produced, contains(ing.id));
        }
      });
    }
  });
}
