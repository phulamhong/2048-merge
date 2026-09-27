import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'core/save_manager.dart';
import 'core/shared_prefs_storage.dart';
import 'data/chapters.dart' as chapter_data;
import 'data/levels.dart' as level_data;
import 'game/farm_merge_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await SharedPrefsStorage.create();
  final saveManager = SaveManager(storage, chapter_data.chapters, level_data.levels);
  runApp(FarmMergeApp(saveManager: saveManager));
}

class FarmMergeApp extends StatelessWidget {
  final SaveManager saveManager;
  const FarmMergeApp({super.key, required this.saveManager});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nông Trại & Bếp Việt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF588157)),
      home: Scaffold(
        backgroundColor: const Color(0xFF2E3A23),
        body: GameWidget(game: FarmMergeGame(saveManager: saveManager)),
      ),
    );
  }
}
