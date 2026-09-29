import 'package:farm_merge_flutter/core/save_manager.dart';
import 'package:farm_merge_flutter/data/chapters.dart' as chapter_data;
import 'package:farm_merge_flutter/data/levels.dart' as level_data;
import 'package:farm_merge_flutter/game/farm_merge_game.dart';
import 'package:farm_merge_flutter/main.dart';
import 'package:farm_merge_flutter/screens/game_screen.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('boots into the home screen, opens level 1-1 with the grid and HUD populated, no exceptions', (
    WidgetTester tester,
  ) async {
    final saveManager = SaveManager(MemoryStorage(), chapter_data.chapters, level_data.levels);
    await tester.pumpWidget(FarmMergeApp(saveManager: saveManager));
    await tester.pump();

    // Home screen: chapter map, no board yet.
    expect(find.text('Nông Trại & Bếp Việt'), findsOneWidget);
    expect(find.byType(GameWidget<FarmMergeGame>), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('1-1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Chapter 1 has an intro scene (docs/GAME_DESIGN_ACTS.md §19.1) shown
    // once before the level-intro dialog — a multi-line sequence, advanced
    // one line at a time ("Tiếp ›" until the last line, then "Tiếp tục").
    expect(find.byType(GameWidget<FarmMergeGame>), findsOneWidget);
    while (find.text('Tiếp ›').evaluate().isNotEmpty) {
      await tester.tap(find.text('Tiếp ›'));
      await tester.pump();
    }
    expect(find.text('Tiếp tục'), findsOneWidget);
    await tester.tap(find.text('Tiếp tục'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Game screen: the level-intro dialog shows before the board is playable.
    expect(find.text('Bắt đầu'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Bắt đầu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final game = tester.widget<GameWidget<FarmMergeGame>>(find.byType(GameWidget<FarmMergeGame>)).game!;
    expect(game.session.level.id, '1-1');
    expect(game.gridComponent.size.x, greaterThan(0));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'home screen refreshes unlock state after returning from a chain of levels replaced via "Màn tiếp"',
    (WidgetTester tester) async {
      final saveManager = SaveManager(MemoryStorage(), chapter_data.chapters, level_data.levels);
      await tester.pumpWidget(FarmMergeApp(saveManager: saveManager));
      await tester.pump();

      await tester.tap(find.text('1-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);

      // Mirrors GameScreen._replaceWith: win the current level, then replace
      // its route with the next one — as "Màn tiếp" does for 1-1 -> 1-2 -> 1-3.
      saveManager.recordWin('1-1', 3, 0);
      navigator.pushReplacement(MaterialPageRoute(builder: (_) => GameScreen(saveManager: saveManager, levelId: '1-2')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      saveManager.recordWin('1-2', 3, 0);
      navigator.pushReplacement(MaterialPageRoute(builder: (_) => GameScreen(saveManager: saveManager, levelId: '1-3')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Mirrors tapping "Về trang chủ" from deep inside the chain.
      navigator.popUntil((route) => route.isFirst);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 1-3 only unlocks once 1-2 is cleared, several `pushReplacement`s deep
      // in a chain the home screen never directly pushed itself into. (1-4/
      // 1-5 and chapter 2 are still legitimately locked, so this only checks 1-3.)
      expect(find.text('1-3'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Tài sản tab shows Nông trại unlocked and its 4 locations, Ẩm thực Việt Nam still locked', (
    WidgetTester tester,
  ) async {
    final saveManager = SaveManager(MemoryStorage(), chapter_data.chapters, level_data.levels);
    await tester.pumpWidget(FarmMergeApp(saveManager: saveManager));
    await tester.pump();

    // The properties screen's own header also reads "Tài sản", so scope the
    // tap to the bottom nav bar specifically.
    await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text('Tài sản')));
    await tester.pump();

    expect(find.text('Nông trại'), findsOneWidget);
    expect(find.text('Ẩm thực Việt Nam'), findsOneWidget);
    expect(find.textContaining('Hoàn thành "Nông trại" để mở khoá'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Nông trại'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    for (final location in ['Chuồng gà', 'Vườn dừa', 'Chuồng bò sữa', 'Vườn rau củ']) {
      expect(find.text(location), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('opening a level with 0 energy shows the energy-blocked dialog instead of an unplayable board', (
    WidgetTester tester,
  ) async {
    final clock = 0;
    final saveManager = SaveManager(MemoryStorage(), chapter_data.chapters, level_data.levels, now: () => clock);
    for (var i = 0; i < saveManager.energyMax; i++) {
      saveManager.spendEnergy();
    }
    expect(saveManager.hasEnergy, false);

    await tester.pumpWidget(FarmMergeApp(saveManager: saveManager));
    await tester.pump();

    await tester.tap(find.text('1-1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // No board, no intro dialog — just the energy dialog with a way out.
    expect(find.text('Hết năng lượng'), findsOneWidget);
    expect(find.byType(GameWidget<FarmMergeGame>), findsNothing);
    expect(find.text('Tiếp ›'), findsNothing);
    expect(find.text('Bắt đầu'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Về trang chủ'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Back home, still no board ever built.
    expect(find.text('Nông Trại & Bếp Việt'), findsOneWidget);
    expect(find.byType(GameWidget<FarmMergeGame>), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
