import 'package:flutter/material.dart';

import '../core/game_session.dart';
import '../core/save_manager.dart';
import '../core/types.dart';
import 'ui_format.dart';

/// Shown once a level stops playing (win or lose) — replaces the old
/// "chạm để chơi tiếp/chơi lại" in-canvas banner with a proper result screen.
class LevelResultDialog extends StatelessWidget {
  final GameSession session;
  final ChapterDef chapter;
  final SaveManager saveManager;
  final RecordWinResult? result;
  final VoidCallback onRetry;
  final VoidCallback? onNext;
  final VoidCallback onHome;

  const LevelResultDialog({
    super.key,
    required this.session,
    required this.chapter,
    required this.saveManager,
    required this.result,
    required this.onRetry,
    required this.onNext,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    final won = session.status == SessionStatus.won;
    return Dialog(
      backgroundColor: const Color(0xFF3A4A2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: won ? _won(context) : _lost(context)),
      ),
    );
  }

  List<Widget> _won(BuildContext context) {
    final ing = chapter.recipe.ingredients.where((i) => i.id == session.level.producesIngredient).firstOrNull;
    final firstClear = result?.firstClear ?? false;
    final canCook = saveManager.canCook(chapter.id);
    return [
      const Text('Hoàn thành!', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(starString(session.stars), style: const TextStyle(color: Color(0xFFE9C46A), fontSize: 34)),
      const SizedBox(height: 8),
      Text('Còn dư ${session.movesLeft} lượt', style: const TextStyle(color: Colors.white70, fontSize: 14)),
      if (firstClear && ing != null) ...[
        const SizedBox(height: 14),
        Text('Nhận nguyên liệu: ${ing.emoji}', style: const TextStyle(color: Colors.white, fontSize: 15)),
      ],
      const SizedBox(height: 8),
      Text('+${result?.coinsEarned ?? 0} 🪙', style: const TextStyle(color: Color(0xFFE9C46A), fontSize: 16, fontWeight: FontWeight.bold)),
      if (canCook) ...[
        const SizedBox(height: 10),
        Text('${chapter.recipe.station} Đủ nguyên liệu — về trang chủ để ${chapter.recipe.verb.toLowerCase()} ${chapter.recipe.name}!',
            textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF8FE388), fontSize: 13)),
      ],
      const SizedBox(height: 22),
      if (onNext != null)
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE76F51), padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: onNext,
            child: const Text('Màn tiếp ›', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      const SizedBox(height: 10),
      _homeButton(),
    ];
  }

  List<Widget> _lost(BuildContext context) {
    final reason = session.loseReason == LoseReason.outOfMoves ? 'Hết lượt đi' : 'Bàn cờ bị kẹt, không còn nước đi';
    return [
      const Text('Chưa đạt!', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Text(reason, style: const TextStyle(color: Colors.white70, fontSize: 15)),
      const SizedBox(height: 22),
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE76F51), padding: const EdgeInsets.symmetric(vertical: 14)),
          onPressed: onRetry,
          child: const Text('↺ Chơi lại', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
      const SizedBox(height: 10),
      _homeButton(),
    ];
  }

  Widget _homeButton() => SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white38), padding: const EdgeInsets.symmetric(vertical: 12)),
      onPressed: onHome,
      child: const Text('Về trang chủ', style: TextStyle(color: Colors.white, fontSize: 15)),
    ),
  );
}
