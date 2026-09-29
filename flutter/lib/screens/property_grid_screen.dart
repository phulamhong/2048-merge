import 'package:flutter/material.dart';

import '../core/save_manager.dart';
import '../core/types.dart';
import '../data/chapters.dart' as chapter_data;
import 'chapter_detail_screen.dart';

const _bg = Color(0xFF2E3A23);
const _panel = Color(0xFF3A4A2C);
const _panelLocked = Color(0xFF2A3320);
const _accentDark = Color(0xFF4F7A37);

/// 1 property's "farm map": a 2-column grid of its chapters as locations
/// (chuồng gà, vườn dừa...) — 1 cell per `property.chapterIds`, using the
/// chapter's own recipe emoji/name since there's no location art yet.
/// Tapping an unlocked cell drills into [ChapterDetailScreen].
class PropertyGridScreen extends StatefulWidget {
  final SaveManager saveManager;
  final PropertyDef property;

  const PropertyGridScreen({super.key, required this.saveManager, required this.property});

  @override
  State<PropertyGridScreen> createState() => _PropertyGridScreenState();
}

class _PropertyGridScreenState extends State<PropertyGridScreen> {
  SaveManager get _save => widget.saveManager;

  List<ChapterDef> get _chapters =>
      [for (final id in widget.property.chapterIds) chapter_data.chapters.firstWhere((c) => c.id == id)];

  Future<void> _openChapter(ChapterDef chapter) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChapterDetailScreen(saveManager: _save, chapter: chapter)));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: Colors.white,
        title: Text('${widget.property.emoji} ${widget.property.name}'),
      ),
      body: SafeArea(
        child: GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.95,
          children: [for (final chapter in _chapters) _LocationTile(save: _save, chapter: chapter, onTap: () => _openChapter(chapter))],
        ),
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final SaveManager save;
  final ChapterDef chapter;
  final VoidCallback onTap;

  const _LocationTile({required this.save, required this.chapter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unlocked = save.isChapterUnlocked(chapter.id);
    final done = save.isCooked(chapter.id);
    return Material(
      color: unlocked ? _panel : _panelLocked,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: unlocked ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(unlocked ? chapter.recipe.emoji : '🔒', style: const TextStyle(fontSize: 44)),
              const SizedBox(height: 10),
              Text(
                chapter.recipe.name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              if (!unlocked)
                const Text('Chưa mở khoá', style: TextStyle(color: Colors.white54, fontSize: 11))
              else if (done)
                const Text('✓ Hoàn thành', style: TextStyle(color: Color(0xFF8FE388), fontSize: 11, fontWeight: FontWeight.bold))
              else
                Text('${chapter.levelIds.where((id) => save.isLevelUnlocked(id) && save.levelStars(id) > 0).length}/${chapter.levelIds.length} màn',
                    style: const TextStyle(color: _accentDark, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
