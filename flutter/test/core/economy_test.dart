import 'package:farm_merge_flutter/core/save_manager.dart';
import 'package:farm_merge_flutter/data/chapters.dart' as chapter_data;
import 'package:farm_merge_flutter/data/levels.dart' as level_data;
import 'package:flutter_test/flutter_test.dart';

SaveManager freshAt(int startMs) {
  var clock = startMs;
  return SaveManager(MemoryStorage(), chapter_data.chapters, level_data.levels, now: () => clock);
}

/// Same as freshAt but exposes a way to advance the injected clock.
class _Clocked {
  int ms;
  _Clocked(this.ms);
  late final SaveManager save = SaveManager(MemoryStorage(), chapter_data.chapters, level_data.levels, now: () => ms);
}

void main() {
  group('coins / gems', () {
    test('spendCoins fails when balance is insufficient, succeeds and deducts otherwise', () {
      final save = freshAt(0);
      expect(save.spendCoins(1), false);
      save.recordWin('1-1', 3, 100);
      final before = save.data.coins;
      expect(before, greaterThanOrEqualTo(100));
      expect(save.spendCoins(50), true);
      expect(save.data.coins, before - 50);
      expect(save.spendCoins(before + 1), false);
    });

    test('spendGems and addGems move the gem balance', () {
      final save = freshAt(0);
      expect(save.spendGems(1), false);
      save.addGems(10);
      expect(save.data.gems, 10);
      expect(save.spendGems(4), true);
      expect(save.data.gems, 6);
    });
  });

  group('energy', () {
    test('starts full at energyMax', () {
      final save = freshAt(0);
      expect(save.energy, save.energyMax);
      expect(save.hasEnergy, true);
    });

    test('spendEnergy decrements and blocks at zero', () {
      final save = freshAt(0);
      for (var i = 0; i < save.energyMax; i++) {
        expect(save.spendEnergy(), true);
      }
      expect(save.energy, 0);
      expect(save.hasEnergy, false);
      expect(save.spendEnergy(), false);
    });

    test('regenerates one point per energyRegenInterval', () {
      final c = _Clocked(0);
      final save = c.save;
      for (var i = 0; i < save.energyMax; i++) {
        save.spendEnergy();
      }
      expect(save.energy, 0);

      c.ms += energyRegenInterval.inMilliseconds - 1;
      expect(save.energy, 0);

      c.ms += 1;
      expect(save.energy, 1);

      c.ms += energyRegenInterval.inMilliseconds * 3;
      expect(save.energy, 4);
    });

    test('never regenerates past energyMax', () {
      final c = _Clocked(0);
      final save = c.save;
      c.ms += energyRegenInterval.inMilliseconds * 100;
      expect(save.energy, save.energyMax);
    });

    test('refillEnergyWithGems fills instantly for a gem cost', () {
      final save = freshAt(0);
      for (var i = 0; i < save.energyMax; i++) {
        save.spendEnergy();
      }
      expect(save.refillEnergyWithGems(gemCost: 20), false);
      save.addGems(20);
      expect(save.refillEnergyWithGems(gemCost: 20), true);
      expect(save.energy, save.energyMax);
      expect(save.data.gems, 0);
    });

    test('timeUntilNextEnergy counts down within the current interval', () {
      final c = _Clocked(0);
      final save = c.save;
      for (var i = 0; i < save.energyMax; i++) {
        save.spendEnergy();
      }
      expect(save.timeUntilNextEnergy, energyRegenInterval);
      c.ms += 5000;
      expect(save.timeUntilNextEnergy, energyRegenInterval - const Duration(milliseconds: 5000));
    });

    test('timeUntilNextEnergy is zero when already full', () {
      final save = freshAt(0);
      expect(save.timeUntilNextEnergy, Duration.zero);
    });
  });
}
