import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;

import '../core/game_session.dart';
import '../core/save_manager.dart';
import '../core/types.dart';
import '../data/chains.dart' as chain_data;
import '../data/levels.dart' as level_data;
import 'grid_component.dart';

/// Top-level Flame game: wires GameSession (pure logic) to GridComponent
/// (rendering) and drag gestures (swipe to slide, short tap to harvest/split).
/// Everything is added directly to the game root rather than `world`, so
/// there's no camera transform to reason about — this is a fixed, non-scrolling
/// single screen.
class FarmMergeGame extends FlameGame with MultiTouchDragDetector {
  final SaveManager saveManager;
  FarmMergeGame({required this.saveManager});

  static const double swipeThreshold = 24;

  late GameSession session;
  late GridComponent gridComponent;
  late TextComponent _titleText;
  late TextComponent _movesText;
  late TextComponent _objectivesText;
  late TextComponent _statusText;
  int _levelIndex = 0;

  final Map<int, Vector2> _dragStart = {};
  final Map<int, Vector2> _dragLast = {};

  @override
  Color backgroundColor() => const Color(0xFF2E3A23);

  @override
  Future<void> onLoad() async {
    _levelIndex = level_data.levelList.indexWhere((l) => !saveManager.isLevelCleared(l.id));
    if (_levelIndex < 0) _levelIndex = 0;
    session = _newSession(_levelIndex);

    gridComponent = GridComponent(session: session);
    add(gridComponent);

    _titleText = TextComponent(position: Vector2(16, 12), textRenderer: _headerStyle());
    _movesText = TextComponent(position: Vector2(16, 42), textRenderer: _bodyStyle());
    _objectivesText = TextComponent(position: Vector2(16, 64), textRenderer: _bodyStyle());
    _statusText = TextComponent(position: Vector2(16, 92), textRenderer: _bodyStyle(color: Colors.amberAccent));
    addAll([_titleText, _movesText, _objectivesText, _statusText]);

    _layout();
    _refreshHud();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) _layout();
  }

  GameSession _newSession(int index) {
    final level = level_data.levelList[index];
    final chain = chain_data.chains[level.chainId]!;
    return GameSession(level, chain);
  }

  void _layout() {
    gridComponent.position = Vector2((size.x - gridComponent.size.x) / 2, (size.y - gridComponent.size.y) / 2 + 40);
  }

  // --- Input -----------------------------------------------------------

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    final p = info.eventPosition.widget.clone();
    _dragStart[pointerId] = p;
    _dragLast[pointerId] = p;
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    _dragLast[pointerId] = info.eventPosition.widget.clone();
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    final start = _dragStart.remove(pointerId);
    final last = _dragLast.remove(pointerId);
    if (start == null || last == null) return;
    _handleGesture(last - start, last);
  }

  @override
  void onDragCancel(int pointerId) {
    _dragStart.remove(pointerId);
    _dragLast.remove(pointerId);
  }

  void _handleGesture(Vector2 delta, Vector2 endPos) {
    if (session.status != SessionStatus.playing) {
      _advance();
      return;
    }
    if (delta.length >= swipeThreshold) {
      final dir = delta.x.abs() > delta.y.abs()
          ? (delta.x > 0 ? Direction.right : Direction.left)
          : (delta.y > 0 ? Direction.down : Direction.up);
      session.swipe(dir);
    } else {
      _handleTap(endPos);
    }
    _afterAction();
  }

  void _handleTap(Vector2 screenPos) {
    final local = screenPos - gridComponent.position;
    const step = GridComponent.cellSize + GridComponent.spacing;
    final col = (local.x / step).floor();
    final row = (local.y / step).floor();
    if (row < 0 || row >= session.level.rows || col < 0 || col >= session.level.cols) return;
    session.tap(row, col);
  }

  void _advance() {
    if (session.status == SessionStatus.won) {
      _levelIndex = (_levelIndex + 1) % level_data.levelList.length;
    }
    session = _newSession(_levelIndex);
    gridComponent.setSession(session);
    _refreshHud();
  }

  // --- HUD ---------------------------------------------------------------

  void _afterAction() {
    gridComponent.sync();
    _refreshHud();
    if (session.status == SessionStatus.won) {
      final result = saveManager.recordWin(session.level.id, session.stars, session.coins);
      _statusText.text = 'Thắng! ${'★' * session.stars} (+${result.coinsEarned} xu) — chạm để chơi tiếp';
    } else if (session.status == SessionStatus.lost) {
      final reason = session.loseReason == LoseReason.outOfMoves ? 'Hết lượt' : 'Kẹt bàn';
      _statusText.text = '$reason — chạm để chơi lại';
    } else {
      _statusText.text = '';
    }
  }

  void _refreshHud() {
    final level = session.level;
    _titleText.text = '${level.id} · ${level.name}';
    _movesText.text = 'Lượt còn: ${session.movesLeft}/${level.moveLimit}   Xu: ${session.coins}';

    final chain = chain_data.chains[level.chainId]!;
    final parts = <String>[];
    for (var i = 0; i < level.objectives.length; i++) {
      final o = level.objectives[i];
      final tierDef = chain.tiers[o.tier - 1];
      var label = tierDef.name;
      if (o.skinId != null) {
        final skin = tierDef.skins?.where((s) => s.id == o.skinId).firstOrNull;
        if (skin != null) label = skin.name;
      }
      parts.add('$label ${session.tracker.progress[i]}/${o.target}');
    }
    _objectivesText.text = 'Mục tiêu: ${parts.join('   ')}';
  }

  TextPaint _headerStyle() =>
      TextPaint(style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold));

  TextPaint _bodyStyle({Color color = Colors.white70}) => TextPaint(style: TextStyle(color: color, fontSize: 15));
}
