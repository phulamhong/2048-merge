import 'package:farm_merge_flutter/core/save_manager.dart';
import 'package:farm_merge_flutter/data/chapters.dart';
import 'package:farm_merge_flutter/data/levels.dart';
import 'package:farm_merge_flutter/data/properties.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('properties', () {
    test('every chapterId in a property exists in the real chapters list', () {
      for (final property in properties) {
        for (final id in property.chapterIds) {
          expect(chapters.where((c) => c.id == id), hasLength(1), reason: 'chapter $id (property ${property.id})');
        }
      }
    });

    test('the farm property is unlocked from the start, the next one starts locked', () {
      final save = SaveManager(MemoryStorage(), chapters, levels);
      expect(save.isPropertyUnlocked(farmProperty), true);
      expect(save.isPropertyUnlocked(cuisineProperty), false);
    });

    test('the next property unlocks once every farm chapter is cooked', () {
      final save = SaveManager(MemoryStorage(), chapters, levels);
      for (final chapterId in farmProperty.chapterIds) {
        final chapter = chapters.firstWhere((c) => c.id == chapterId);
        for (final levelId in chapter.levelIds) {
          save.recordWin(levelId, 3, 0);
        }
        save.cook(chapterId);
      }
      expect(save.isPropertyDone(farmProperty), true);
      expect(save.isPropertyUnlocked(cuisineProperty), true);
    });
  });
}
