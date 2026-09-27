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
import 'objective_icon_component.dart';
import 'tile_look.dart';

/// Coin/gem costs for the pay-per-use boosters. Placeholder pricing — no
/// game-design sign-off yet, tune once real playtesting data exists.
const undoCost = 15;
const shuffleCost = 20;
const extraMovesCost = 25;
const extraMovesAmount = 5;
const energyRefillGemCost = 20;

/// Stand-in for "this wrapping label has nothing to show right now". A truly
/// empty string makes `TextBoxComponent` lay out zero lines, which computes a
/// zero-height image and crashes `toImageSafe` ("Invalid image dimensions");
/// a lone space keeps the box a valid, if invisible, one-line box.
const _blank = ' ';

class _Button {
  Rect rect;
  final VoidCallback onTap;
  _Button(this.rect, this.onTap);
}

/// Top-level Flame game: wires GameSession (pure logic) to GridComponent
/// (rendering) and drag gestures (swipe to slide, short tap to harvest/split)
/// for exactly one level. Plays one level per instance — [GameScreen] creates
/// a fresh one for "chơi lại"/"màn tiếp theo" and owns the pre-level and
/// post-level dialogs via [onLevelEnd], so this class never decides what
/// happens after a level ends, only that it did.
class FarmMergeGame extends FlameGame with MultiTouchDragDetector {
  final SaveManager saveManager;
  final String levelId;
  final void Function(GameSession session, RecordWinResult? winResult)? onLevelEnd;

  FarmMergeGame({required this.saveManager, required this.levelId, this.onLevelEnd});

  static const double swipeThreshold = 24;
  static const double _objectiveIconSize = 44;
  static const double _objectiveGap = 18;
  static const double _gridTop = 210;
  static const double _boosterMargin = 16;
  static const double _boosterRowY = 148;
  static const double _boosterRowHeight = 40;

  late GameSession session;
  late GridComponent gridComponent;
  late TextComponent _titleText;
  late TextComponent _movesText;
  late TextComponent _economyText;
  late TextBoxComponent _energyRefillLabel;
  late TextBoxComponent _undoLabel;
  late TextBoxComponent _shuffleLabel;
  late TextBoxComponent _extraMovesLabel;
  late TextBoxComponent _hintText;
  final _objectiveIcons = <ObjectiveIconComponent>[];

  bool _energyBlocked = false;
  bool _busy = false;
  bool _ended = false;

  final List<_Button> _buttons = [];
  final Map<int, Vector2> _dragStart = {};
  final Map<int, Vector2> _dragLast = {};

  @override
  Color backgroundColor() => const Color(0xFF2E3A23);

  @override
  Future<void> onLoad() async {
    final level = level_data.levels[levelId]!;
    final chain = chain_data.chains[level.chainId]!;
    session = GameSession(level, chain);
    _energyBlocked = !saveManager.spendEnergy();

    gridComponent = GridComponent(session: session);
    add(gridComponent);

    _titleText = TextComponent(position: Vector2(16, 12), textRenderer: _headerStyle());
    _movesText = TextComponent(position: Vector2(16, 42), textRenderer: _bodyStyle());
    _economyText = TextComponent(position: Vector2(16, 64), textRenderer: _bodyStyle(color: Colors.amber.shade200));
    _energyRefillLabel = _wrappingLabel(color: Colors.lightGreenAccent, fontSize: 13);
    _undoLabel = _wrappingLabel(color: Colors.lightGreenAccent, fontSize: 12);
    _shuffleLabel = _wrappingLabel(color: Colors.lightGreenAccent, fontSize: 12);
    _extraMovesLabel = _wrappingLabel(color: Colors.lightGreenAccent, fontSize: 12);
    _hintText = _wrappingLabel(color: Colors.white54, fontSize: 13);
    addAll([
      _titleText,
      _movesText,
      _economyText,
      _energyRefillLabel,
      _undoLabel,
      _shuffleLabel,
      _extraMovesLabel,
      _hintText,
    ]);

    for (final o in level.objectives) {
      final icon = ObjectiveIconComponent(
        look: objectiveLookOf(chain, o),
        target: o.target,
        position: Vector2.zero(),
        size: Vector2.all(_objectiveIconSize),
      );
      _objectiveIcons.add(icon);
      add(icon);
    }

    _layout();
    _refreshHud();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) _layout();
  }

  /// Smallest game width worth laying out for — below this, `size.x` is
  /// either genuinely zero (a Flame `onGameResize` fired before the widget
  /// has real constraints, e.g. in tests) or too small for the 3 booster
  /// columns to each get a valid (positive) max text width.
  static const double _minLayoutWidth = 200;

  void _layout() {
    if (size.x < _minLayoutWidth) return;

    gridComponent.position = Vector2((size.x - gridComponent.size.x) / 2, _gridTop);

    final n = _objectiveIcons.length;
    final totalW = n * _objectiveIconSize + (n - 1) * _objectiveGap;
    var x = (size.x - totalW) / 2;
    for (final icon in _objectiveIcons) {
      icon.position = Vector2(x, 92);
      x += _objectiveIconSize + _objectiveGap;
    }

    final hintMaxWidth = size.x - 2 * _boosterMargin;
    _hintText.position = Vector2(size.x / 2, gridComponent.position.y + gridComponent.size.y + 20);
    _hintText.boxConfig = _hintText.boxConfig.copyWith(maxWidth: hintMaxWidth);

    final rowWidth = size.x - 2 * _boosterMargin;
    final colW = rowWidth / 3;
    _energyRefillLabel.position = Vector2(size.x / 2, _boosterRowY);
    _energyRefillLabel.boxConfig = _energyRefillLabel.boxConfig.copyWith(maxWidth: rowWidth);
    _undoLabel.position = Vector2(_boosterMargin + colW * 0.5, _boosterRowY);
    _undoLabel.boxConfig = _undoLabel.boxConfig.copyWith(maxWidth: colW - 8);
    _shuffleLabel.position = Vector2(_boosterMargin + colW * 1.5, _boosterRowY);
    _shuffleLabel.boxConfig = _shuffleLabel.boxConfig.copyWith(maxWidth: colW - 8);
    _extraMovesLabel.position = Vector2(_boosterMargin + colW * 2.5, _boosterRowY);
    _extraMovesLabel.boxConfig = _extraMovesLabel.boxConfig.copyWith(maxWidth: colW - 8);

    _rebuildBoosterButtons();
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
    final tapPoint = Offset(endPos.x, endPos.y);
    for (final b in _buttons) {
      if (b.rect.contains(tapPoint)) {
        b.onTap();
        return;
      }
    }

    if (_energyBlocked || _busy || session.status != SessionStatus.playing) return;

    List<GameEvent> events;
    if (delta.length >= swipeThreshold) {
      final dir = delta.x.abs() > delta.y.abs()
          ? (delta.x > 0 ? Direction.right : Direction.left)
          : (delta.y > 0 ? Direction.down : Direction.up);
      events = session.swipe(dir);
    } else {
      final local = endPos - gridComponent.position;
      const step = GridComponent.cellSize + GridComponent.spacing;
      final col = (local.x / step).floor();
      final row = (local.y / step).floor();
      if (row < 0 || row >= session.level.rows || col < 0 || col >= session.level.cols) return;
      events = session.tap(row, col);
    }
    _runTurn(events);
  }

  void _runTurn(List<GameEvent> events) {
    if (events.isEmpty) return;
    _busy = true;
    gridComponent.playEvents(events, _harvestTarget).then((_) {
      _busy = false;
      _refreshHud();
      _maybeEndLevel();
    });
  }

  Vector2 _harvestTarget(HarvestEvent e) {
    final idx = e.objectiveIndex;
    final Vector2 globalTarget;
    if (idx != null && idx < _objectiveIcons.length) {
      final icon = _objectiveIcons[idx];
      globalTarget = icon.position + icon.size / 2;
    } else {
      globalTarget = Vector2(size.x - 20, 20);
    }
    return gridComponent.toLocal(globalTarget);
  }

  /// Records the win once and hands off to [onLevelEnd] the first time the
  /// session stops playing; re-armed if a booster (undo) brings it back.
  void _maybeEndLevel() {
    if (session.status == SessionStatus.playing) {
      _ended = false;
      return;
    }
    if (_ended) return;
    _ended = true;
    RecordWinResult? result;
    if (session.status == SessionStatus.won) {
      result = saveManager.recordWin(session.level.id, session.stars, session.coins);
    }
    onLevelEnd?.call(session, result);
  }

  // --- Boosters ------------------------------------------------------------

  void _useUndo() {
    if (!session.canUndo) return;
    if (!saveManager.spendCoins(undoCost)) return;
    session = session.previousSnapshot!;
    gridComponent.setSession(session);
    _syncAfterBooster();
  }

  void _useShuffle() {
    if (session.status != SessionStatus.playing) return;
    if (!saveManager.spendCoins(shuffleCost)) return;
    session.shuffleBoard();
    _syncAfterBooster();
  }

  void _useExtraMoves() {
    if (session.status == SessionStatus.won) return;
    if (session.status == SessionStatus.lost && session.loseReason == LoseReason.stuck) return;
    if (!saveManager.spendCoins(extraMovesCost)) return;
    session.addBonusMoves(extraMovesAmount);
    _syncAfterBooster();
  }

  void _refillEnergy() {
    if (!_energyBlocked) return;
    if (!saveManager.refillEnergyWithGems(gemCost: energyRefillGemCost)) return;
    _energyBlocked = false;
    _refreshHud();
  }

  void _syncAfterBooster() {
    gridComponent.hardSync();
    _refreshHud();
    _maybeEndLevel();
  }

  // --- HUD ---------------------------------------------------------------

  void _refreshHud() {
    final level = session.level;
    _titleText.text = level.id;
    _movesText.text = 'Lượt còn: ${session.movesLeft}/${level.moveLimit}   Xu: ${session.coins}';
    _economyText.text = '⚡ ${saveManager.energy}/${saveManager.energyMax}   💎 ${saveManager.data.gems}';
    _hintText.text = level.hint ?? _blank;

    for (var i = 0; i < _objectiveIcons.length; i++) {
      _objectiveIcons[i].updateProgress(session.tracker.progress[i]);
    }

    if (_energyBlocked) {
      _energyRefillLabel.text = 'Hết năng lượng — chạm đây để nạp ($energyRefillGemCost 💎)';
      _undoLabel.text = _blank;
      _shuffleLabel.text = _blank;
      _extraMovesLabel.text = _blank;
    } else {
      _energyRefillLabel.text = _blank;
      _undoLabel.text = '↩ Hoàn tác\n($undoCost xu)';
      _shuffleLabel.text = '🔀 Xáo bàn\n($shuffleCost xu)';
      _extraMovesLabel.text = '➕ $extraMovesAmount lượt\n($extraMovesCost xu)';
    }
    _rebuildBoosterButtons();
  }

  /// Booster tap zones are a fixed row geometry, independent of how the
  /// labels above them wrap — avoids the old bug where a hit-rect computed
  /// from rendered text bounds went stale once the text no longer fit on
  /// one line.
  void _rebuildBoosterButtons() {
    final rowWidth = size.x - 2 * _boosterMargin;
    final rowRect = Rect.fromLTWH(_boosterMargin, _boosterRowY - 6, rowWidth, _boosterRowHeight);
    _buttons.clear();
    if (_energyBlocked) {
      _buttons.add(_Button(rowRect, _refillEnergy));
    } else {
      final colW = rowWidth / 3;
      _buttons
        ..add(_Button(Rect.fromLTWH(rowRect.left, rowRect.top, colW, rowRect.height), _useUndo))
        ..add(_Button(Rect.fromLTWH(rowRect.left + colW, rowRect.top, colW, rowRect.height), _useShuffle))
        ..add(_Button(Rect.fromLTWH(rowRect.left + colW * 2, rowRect.top, colW, rowRect.height), _useExtraMoves));
    }
  }

  /// A center-aligned label that wraps within [TextBoxConfig.maxWidth]
  /// instead of running off the edge of the screen — [maxWidth] is set per
  /// frame in [_layout] once the actual game width is known.
  TextBoxComponent _wrappingLabel({required Color color, required double fontSize}) => TextBoxComponent(
    text: _blank,
    textRenderer: _bodyStyle(color: color, fontSize: fontSize),
    boxConfig: const TextBoxConfig(maxWidth: 200, margins: EdgeInsets.zero),
    align: Anchor.topCenter,
    anchor: Anchor.topCenter,
  );

  TextPaint _headerStyle() =>
      TextPaint(style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold));

  TextPaint _bodyStyle({Color color = Colors.white70, double fontSize = 15}) =>
      TextPaint(style: TextStyle(color: color, fontSize: fontSize));
}
