import 'package:farm_merge_flutter/core/save_manager.dart';
import 'package:farm_merge_flutter/data/chapters.dart' as chapter_data;
import 'package:farm_merge_flutter/data/levels.dart' as level_data;
import 'package:farm_merge_flutter/game/farm_merge_game.dart';
import 'package:farm_merge_flutter/game/grid_component.dart';
import 'package:farm_merge_flutter/screens/game_screen.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a 6x6 board is scaled down to fit inside a narrow phone screen, and taps still map to the right cell', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 667));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final saveManager = SaveManager(MemoryStorage(), chapter_data.chapters, level_data.levels);
    // '2c-5' is a 6x6 boss level: 6 * cellSize(76) + 5 * spacing(6) = 486px wide, wider than the 375px screen.
    await tester.pumpWidget(MaterialApp(home: GameScreen(saveManager: saveManager, levelId: '2c-5')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Bắt đầu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final game = tester.widget<GameWidget<FarmMergeGame>>(find.byType(GameWidget<FarmMergeGame>)).game!;
    expect(game.session.level.rows, 6);
    expect(game.session.level.cols, 6);
    expect(game.gridComponent.scale.x, lessThan(1.0));

    final boardW = game.gridComponent.size.x * game.gridComponent.scale.x;
    final boardH = game.gridComponent.size.y * game.gridComponent.scale.y;
    expect(game.gridComponent.position.x, greaterThanOrEqualTo(0));
    expect(game.gridComponent.position.x + boardW, lessThanOrEqualTo(game.size.x + 0.01));
    expect(game.gridComponent.position.y + boardH, lessThanOrEqualTo(game.size.y + 0.01));

    // A tap on the visual center of the top-left cell should resolve to (row 0, col 0):
    // GridComponent.toLocal must account for the scale applied to fit the screen.
    final cellCenterGlobal =
        game.gridComponent.position + Vector2.all(GridComponent.cellSize / 2) * game.gridComponent.scale.x;
    final local = game.gridComponent.toLocal(cellCenterGlobal);
    const step = GridComponent.cellSize + GridComponent.spacing;
    expect((local.x / step).floor(), 0);
    expect((local.y / step).floor(), 0);

    expect(tester.takeException(), isNull);
  });
}
