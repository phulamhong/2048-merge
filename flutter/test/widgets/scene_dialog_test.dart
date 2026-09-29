import 'package:farm_merge_flutter/data/scenes.dart';
import 'package:farm_merge_flutter/widgets/scene_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _tapArea = Key('scene_dialog_tap_area');

Future<void> _openScene(WidgetTester tester, SceneDef scene) async {
  final navKey = GlobalKey<NavigatorState>();
  await tester.pumpWidget(MaterialApp(navigatorKey: navKey, home: const Scaffold(body: SizedBox.shrink())));
  await tester.pump();
  showDialog<void>(context: navKey.currentContext!, barrierDismissible: false, builder: (_) => SceneDialog(scene: scene));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('every scene renders without layout overflow at a narrow phone width', (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 667));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    for (final scene in scenes.values) {
      await _openScene(tester, scene);
      for (var i = 0; i < scene.lines.length; i++) {
        expect(tester.takeException(), isNull, reason: '${scene.id} line $i overflowed');
        await tester.tap(find.byKey(_tapArea));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull, reason: '${scene.id} overflowed on close');
    }
  });

  testWidgets('one tap advances exactly one line (no double-advance from the outer + button gesture detectors)', (
    tester,
  ) async {
    await _openScene(tester, hoi1Open);

    for (var i = 0; i < hoi1Open.lines.length - 1; i++) {
      await tester.tap(find.byKey(_tapArea));
      await tester.pump();
      expect(find.byType(SceneDialog), findsOneWidget, reason: 'dialog closed early after tap ${i + 1}');
      expect(find.text(hoi1Open.lines[i + 1].text), findsOneWidget, reason: 'line ${i + 1} was skipped');
    }
    await tester.tap(find.byKey(_tapArea));
    await tester.pumpAndSettle();
    expect(find.byType(SceneDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
