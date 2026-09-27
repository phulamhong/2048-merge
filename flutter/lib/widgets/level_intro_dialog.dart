import 'package:flutter/material.dart';

import '../core/types.dart';
import 'objective_chip.dart';

const _modeLabel = {LevelMode.merge: 'Gộp', LevelMode.split: 'Tách', LevelMode.mixed: 'Gộp + Tách'};

/// Shown before a level starts, so the player sees the target before
/// swiping — the board underneath already fills in for a "get ready" peek.
class LevelIntroDialog extends StatelessWidget {
  final LevelConfig level;
  final ChainDef chain;
  final ChapterDef chapter;

  const LevelIntroDialog({super.key, required this.level, required this.chain, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF3A4A2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              level.id,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Kiểu: ${_modeLabel[level.mode]} · ${chapter.recipe.name}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            const Text('Mục tiêu', style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 18,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [for (final o in level.objectives) ObjectiveChip(chain: chain, objective: o)],
            ),
            const SizedBox(height: 16),
            Text('Lượt đi: ${level.moveLimit}', style: const TextStyle(color: Colors.white70, fontSize: 14)),
            if (level.hint != null) ...[
              const SizedBox(height: 10),
              Text(level.hint!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ],
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6A994E), padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Bắt đầu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
