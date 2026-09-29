import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../core/game_session.dart';
import '../core/save_manager.dart';
import '../core/types.dart';
import '../data/chains.dart' as chain_data;
import '../data/chapters.dart' as chapter_data;
import '../data/levels.dart' as level_data;
import '../data/scenes.dart' as scene_data;
import '../game/farm_merge_game.dart';
import '../widgets/energy_blocked_dialog.dart';
import '../widgets/level_intro_dialog.dart';
import '../widgets/level_result_dialog.dart';
import '../widgets/scene_dialog.dart';

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
  FarmMergeGame? _game;
  bool _startShown = false;

  LevelConfig get _level => level_data.levels[widget.levelId]!;
  ChainDef get _chain => chain_data.chains[_level.chainId]!;
  ChapterDef get _chapter => chapter_data.chapters.firstWhere((c) => c.levelIds.contains(widget.levelId));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  /// Checks energy *before* ever building the board — previously
  /// FarmMergeGame's own onLoad() spent energy and set an internal blocked
  /// flag independent of anything this screen did, so refilling energy from
  /// a dialog shown after the board was already built couldn't un-stick it.
  /// Now: no energy, no board — just this screen's own dialog, which is the
  /// single source of truth and always offers a way out.
  Future<void> _start() async {
    if (!mounted || _startShown) return;
    _startShown = true;

    if (!widget.saveManager.hasEnergy) {
      final refilled = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => EnergyBlockedDialog(saveManager: widget.saveManager),
      );
      if (!mounted) return;
      if (refilled != true) {
        Navigator.of(context).pop();
        return;
      }
    }

    setState(() {
      _game = FarmMergeGame(
        saveManager: widget.saveManager,
        levelId: widget.levelId,
        onLevelEnd: _onLevelEnd,
        onHome: () => Navigator.of(context).popUntil((route) => route.isFirst),
      );
    });
    await _maybeShowChapterScene();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => LevelIntroDialog(level: _level, chain: _chain, chapter: _chapter),
    );
  }

  /// Shows the chapter's [ChapterDef.introSceneId] scene once, the first
  /// time the player reaches that chapter's first level.
  Future<void> _maybeShowChapterScene() async {
    final sceneId = _chapter.introSceneId;
    if (sceneId == null) return;
    if (_chapter.levelIds.first != widget.levelId) return;
    if (widget.saveManager.hasSeenScene(sceneId)) return;
    final scene = scene_data.scenes[sceneId];
    if (scene == null) return;
    await showDialog<void>(context: context, barrierDismissible: false, builder: (_) => SceneDialog(scene: scene));
    widget.saveManager.markSceneSeen(sceneId);
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
    final game = _game;
    return Scaffold(
      backgroundColor: const Color(0xFF2E3A23),
      // Blank until energy is confirmed available (see _start) — the
      // EnergyBlockedDialog is the only thing shown over this in that case,
      // so there's never an unplayable board underneath it.
      body: SafeArea(child: game == null ? const SizedBox.shrink() : GameWidget(game: game)),
    );
  }
}
