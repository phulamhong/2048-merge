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
    // once before the level-intro dialog — dismiss it first.
    expect(find.byType(GameWidget<FarmMergeGame>), findsOneWidget);
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
}
