import 'package:flutter/material.dart';

import '../core/save_manager.dart';
import '../core/types.dart';
import '../data/chapters.dart' as chapter_data;
import '../data/levels.dart' as level_data;
import '../main.dart' show routeObserver;
import '../widgets/ui_format.dart';
import 'game_screen.dart';

const _bg = Color(0xFF2E3A23);
const _panel = Color(0xFF3A4A2C);
const _panelLocked = Color(0xFF2A3320);
const _accent = Color(0xFF6A994E);
const _accentDark = Color(0xFF4F7A37);
const _warm = Color(0xFFE76F51);

/// Chapter map / home screen — port of src/scenes/ChapterMapScene.ts. Shows
/// every chapter with its recipe, ingredient progress, and level buttons;
/// tapping an unlocked level opens [GameScreen].
class HomeScreen extends StatefulWidget {
  final SaveManager saveManager;
  const HomeScreen({super.key, required this.saveManager});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  SaveManager get _save => widget.saveManager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of<void>(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// Called whenever a pushed route above this one is popped and Home
  /// becomes visible again. Refreshes unconditionally rather than relying on
  /// awaiting the original `Navigator.push` future, which only tracks the
  /// single route it pushed — fragile once "Màn tiếp" replaces that route
  /// with the next level's (chained several levels deep via
  /// `pushReplacement`), the reported symptom being stars/unlocks for
  /// levels played after the first "Màn tiếp" not showing up back home.
  @override
  void didPopNext() {
    if (mounted) setState(() {});
  }

  void _openLevel(String levelId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => GameScreen(saveManager: _save, levelId: levelId)));
  }

  void _cook(String chapterId) {
    setState(() => _save.cook(chapterId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _Header(save: _save),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: chapter_data.chapters.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ChapterCard(save: _save, chapter: chapter_data.chapters[i], onOpenLevel: _openLevel, onCook: _cook),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final SaveManager save;
  const _Header({required this.save});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nông Trại & Bếp Việt', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('🪙 ${save.data.coins}', style: const TextStyle(color: Color(0xFFE9C46A), fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Text('💎 ${save.data.gems}', style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Text('⚡ ${save.energy}/${save.energyMax}', style: const TextStyle(color: Colors.white70, fontSize: 17)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final SaveManager save;
  final ChapterDef chapter;
  final void Function(String levelId) onOpenLevel;
  final void Function(String chapterId) onCook;

  const _ChapterCard({required this.save, required this.chapter, required this.onOpenLevel, required this.onCook});

  @override
  Widget build(BuildContext context) {
    final unlocked = save.isChapterUnlocked(chapter.id);
    final r = chapter.recipe;
    return Container(
      decoration: BoxDecoration(color: unlocked ? _panel : _panelLocked, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(chapter.name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            '${r.verb} ${r.emoji} ${r.name} — cần:',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final ing in r.ingredients)
                Opacity(
                  opacity: save.isCooked(chapter.id) || (save.data.inventory[ing.id] ?? 0) > 0 ? 1 : 0.3,
                  child: Column(
                    children: [
                      Text(ing.emoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 2),
                      Text(ing.name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final id in chapter.levelIds) Expanded(child: _LevelButton(save: save, levelId: id, onTap: () => onOpenLevel(id))),
            ],
          ),
          const SizedBox(height: 14),
          if (!unlocked)
            const Text('🔒 Hoàn thành chương trước để mở', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 13))
          else if (save.isCooked(chapter.id))
            const Text('✓ Đã chế biến', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF8FE388), fontSize: 15, fontWeight: FontWeight.bold))
          else if (save.canCook(chapter.id))
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: _warm, padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: () => onCook(chapter.id),
                child: Text('${r.station} ${r.verb} ${r.name}!', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          else
            const Text('Qua mỗi màn để nhận 1 nguyên liệu', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 13)),
        ],
      ),
    );
  }
}

class _LevelButton extends StatelessWidget {
  final SaveManager save;
  final String levelId;
  final VoidCallback onTap;

  const _LevelButton({required this.save, required this.levelId, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final level = level_data.levels[levelId]!;
    final open = save.isLevelUnlocked(levelId);
    final stars = save.levelStars(levelId);
    final color = !open ? Colors.white24 : (level.boss ? _warm : (stars > 0 ? _accentDark : _accent));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: open ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(open ? levelId : '🔒', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text(
                  !open ? '' : (stars > 0 ? starString(stars) : (level.boss ? 'BOSS' : '·')),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
