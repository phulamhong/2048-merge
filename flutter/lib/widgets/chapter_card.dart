import 'package:flutter/material.dart';

import '../core/save_manager.dart';
import '../core/types.dart';
import '../data/levels.dart' as level_data;
import 'ui_format.dart';

const _panel = Color(0xFF3A4A2C);
const _panelLocked = Color(0xFF2A3320);
const _accent = Color(0xFF6A994E);
const _accentDark = Color(0xFF4F7A37);
const _warm = Color(0xFFE76F51);

/// 1 chapter's full card: name, ingredient progress, level buttons, and the
/// cook/locked/done footer — used both inline in the "Chơi" tab's list
/// (HomeScreen) and as the sole content of [ChapterDetailScreen] when
/// opened from a location in the "Tài sản" (property) world-map grid.
class ChapterCard extends StatelessWidget {
  final SaveManager save;
  final ChapterDef chapter;
  final void Function(String levelId) onOpenLevel;
  final void Function(String chapterId) onCook;

  const ChapterCard({super.key, required this.save, required this.chapter, required this.onOpenLevel, required this.onCook});

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
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 8,
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
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final id in chapter.levelIds)
                SizedBox(width: 64, child: _LevelButton(save: save, levelId: id, onTap: () => onOpenLevel(id))),
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
    return Material(
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
    );
  }
}
