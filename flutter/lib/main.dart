import 'package:flutter/material.dart';

import 'core/save_manager.dart';
import 'core/shared_prefs_storage.dart';
import 'data/chapters.dart' as chapter_data;
import 'data/levels.dart' as level_data;
import 'screens/home_screen.dart';

/// Lets [HomeScreen] know whenever it becomes the visible route again — see
/// its `didPopNext` for why this is needed instead of just awaiting the
/// initial `Navigator.push`.
final routeObserver = RouteObserver<ModalRoute<void>>();

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
      navigatorObservers: [routeObserver],
      home: HomeScreen(saveManager: saveManager),
    );
  }
}
