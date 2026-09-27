import 'package:farm_merge_flutter/core/save_manager.dart';
import 'package:farm_merge_flutter/data/chapters.dart' as chapter_data;
import 'package:farm_merge_flutter/data/levels.dart' as level_data;
import 'package:farm_merge_flutter/game/farm_merge_game.dart';
import 'package:farm_merge_flutter/main.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('boots into level 1-1 with the grid and HUD populated, no exceptions', (WidgetTester tester) async {
    final saveManager = SaveManager(MemoryStorage(), chapter_data.chapters, level_data.levels);
    await tester.pumpWidget(FarmMergeApp(saveManager: saveManager));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(GameWidget<FarmMergeGame>), findsOneWidget);
    expect(tester.takeException(), isNull);

    final game = tester.widget<GameWidget<FarmMergeGame>>(find.byType(GameWidget<FarmMergeGame>)).game!;
    expect(game.session.level.id, '1-1');
    expect(game.gridComponent.size.x, greaterThan(0));
  });
}
