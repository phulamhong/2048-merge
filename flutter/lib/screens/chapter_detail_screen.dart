import 'package:flutter/material.dart';

import '../core/save_manager.dart';
import '../core/types.dart';
import '../widgets/chapter_card.dart';
import 'game_screen.dart';

const _bg = Color(0xFF2E3A23);

/// Drill-down from 1 location tile in [PropertyGridScreen] — just the same
/// [ChapterCard] used inline in the "Chơi" tab's list (HomeScreen), on its
/// own screen so a location can be opened without leaving the map metaphor.
class ChapterDetailScreen extends StatefulWidget {
  final SaveManager saveManager;
  final ChapterDef chapter;

  const ChapterDetailScreen({super.key, required this.saveManager, required this.chapter});

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  SaveManager get _save => widget.saveManager;

  Future<void> _openLevel(String levelId) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => GameScreen(saveManager: _save, levelId: levelId)));
    if (mounted) setState(() {});
  }

  void _cook(String chapterId) {
    setState(() => _save.cook(chapterId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(backgroundColor: _bg, foregroundColor: Colors.white, title: Text(widget.chapter.name)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ChapterCard(save: _save, chapter: widget.chapter, onOpenLevel: _openLevel, onCook: _cook),
        ),
      ),
    );
  }
}
