import 'package:flutter/material.dart';

import '../core/types.dart';
import 'objective_chip.dart';

const _modeLabel = {
  LevelMode.merge: 'Gộp',
  LevelMode.split: 'Tách',
  LevelMode.mixed: 'Gộp + Tách',
};

/// Shown before a level starts, so the player sees the target before
/// swiping — the board underneath already fills in for a "get ready" peek.
class LevelIntroDialog extends StatelessWidget {
  final LevelConfig level;
  final ChainDef chain;
  final ChapterDef chapter;

  const LevelIntroDialog({
    super.key,
    required this.level,
    required this.chain,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF3A4A2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                level.id,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kiểu: ${_modeLabel[level.mode]} · ${chapter.recipe.name}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),
              const Text(
                'Mục tiêu',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 18,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  for (final o in level.objectives)
                    ObjectiveChip(chain: chain, objective: o),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Lượt đi: ${level.moveLimit}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              if (level.decaySpawn != null) ...[
                const SizedBox(height: 16),
                const _ObstacleWarning(),
              ],
              if (level.hint != null) ...[
                const SizedBox(height: 10),
                Text(
                  level.hint!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6A994E),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Bắt đầu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Name/handling/consequence for the "Mạng nhện" (decay) obstacle — shown on
/// every level that has one, so it's never a surprise mid-level.
class _ObstacleWarning extends StatelessWidget {
  const _ObstacleWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFB23A2E).withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFB23A2E).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🕸️', style: TextStyle(fontSize: 26)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mạng nhện',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Vuốt cho tile chạm vào nó, đủ 5 lần thì dọn sạch — đừng để lan rộng. Để lâu, 2 ô mạng nhện '
                  'sẽ hợp thành 1 ô nặng, phải dùng Bộ Sửa Chữa (💎) mới dọn được.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
