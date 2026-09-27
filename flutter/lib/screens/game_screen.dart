import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../core/game_session.dart';
import '../core/save_manager.dart';
import '../core/types.dart';
import '../data/chains.dart' as chain_data;
import '../data/chapters.dart' as chapter_data;
import '../data/levels.dart' as level_data;
import '../game/farm_merge_game.dart';
import '../widgets/level_intro_dialog.dart';
import '../widgets/level_result_dialog.dart';

/// Hosts the Flame board for exactly one level, plus the two Flutter dialogs
/// around it: the target screen shown before the first move, and the result
/// screen shown once the level is won or lost.
class GameScreen extends StatefulWidget {
  final SaveManager saveManager;
  final String levelId;

  const GameScreen({super.key, required this.saveManager, required this.levelId});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final FarmMergeGame _game;
  bool _introShown = false;

  LevelConfig get _level => level_data.levels[widget.levelId]!;
  ChainDef get _chain => chain_data.chains[_level.chainId]!;
  ChapterDef get _chapter => chapter_data.chapters.firstWhere((c) => c.levelIds.contains(widget.levelId));

  @override
  void initState() {
    super.initState();
    _game = FarmMergeGame(saveManager: widget.saveManager, levelId: widget.levelId, onLevelEnd: _onLevelEnd);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showIntro());
  }

  Future<void> _showIntro() async {
    if (!mounted || _introShown) return;
    _introShown = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => LevelIntroDialog(level: _level, chain: _chain, chapter: _chapter),
    );
  }

  void _onLevelEnd(GameSession session, RecordWinResult? result) {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => LevelResultDialog(
        session: session,
        chapter: _chapter,
        saveManager: widget.saveManager,
        result: result,
        onRetry: () => _replaceWith(widget.levelId),
        onNext: _nextLevelId() == null ? null : () => _replaceWith(_nextLevelId()!),
        onHome: () => Navigator.of(context).popUntil((route) => route.isFirst),
      ),
    );
  }

  String? _nextLevelId() {
    final idx = _chapter.levelIds.indexOf(widget.levelId);
    if (idx < 0 || idx + 1 >= _chapter.levelIds.length) return null;
    return _chapter.levelIds[idx + 1];
  }

  void _replaceWith(String levelId) {
    Navigator.of(context).pop(); // close the result dialog
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => GameScreen(saveManager: widget.saveManager, levelId: levelId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3A23),
      body: SafeArea(child: GameWidget(game: _game)),
    );
  }
}
