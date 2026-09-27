import 'package:farm_merge_flutter/core/save_manager.dart';
import 'package:farm_merge_flutter/data/chapters.dart';
import 'package:farm_merge_flutter/data/levels.dart';
import 'package:flutter_test/flutter_test.dart';

SaveManager fresh() => SaveManager(MemoryStorage(), chapters, levels);

void main() {
  group('SaveManager', () {
    test('unlocks levels sequentially and chapters after cooking', () {
      final save = fresh();
      expect(save.isLevelUnlocked('1-1'), true);
      expect(save.isLevelUnlocked('1-2'), false);
      expect(save.isLevelUnlocked('2-1'), false);
      save.recordWin('1-1', 2, 0);
      expect(save.isLevelUnlocked('1-2'), true);
    });

    test('grants the ingredient only on first clear and keeps best stars', () {
      final save = fresh();
      save.recordWin('1-1', 1, 0);
      save.recordWin('1-1', 3, 0);
      save.recordWin('1-1', 2, 0);
      expect(save.data.inventory['nest'], 1);
      expect(save.levelStars('1-1'), 3);
      expect(save.data.coins, 30);
    });

    test('cooks once all ingredients are collected and unlocks the next chapter', () {
      final save = fresh();
      for (final id in chapters[0].levelIds) {
        expect(save.canCook('ch1'), false);
        save.recordWin(id, 1, 0);
      }
      expect(save.canCook('ch1'), true);
      expect(save.cook('ch1'), true);
      expect(save.data.decor, contains('coop'));
      expect(save.canCook('ch1'), false);
      expect(save.isLevelUnlocked('2-1'), true);
    });

    test('persists to storage and survives corrupt data', () {
      final storage = MemoryStorage();
      SaveManager(storage, chapters, levels).recordWin('1-1', 3, 5);
      expect(SaveManager(storage, chapters, levels).levelStars('1-1'), 3);
      storage.setItem(saveKey, '{not json');
      expect(SaveManager(storage, chapters, levels).data.coins, 0);
    });
  });
}
