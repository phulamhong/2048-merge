// Level-feasibility simulator — Dart port of the TS `sim/simulate.ts` greedy
// bot (repo root, `npm run sim`), pointed at the real Flutter `GameSession`
// instead of the TS one so it also sees obstacles ("Mạng nhện"/decay), which
// the TS engine has no concept of at all.
//
// Run: `dart run tool/simulate.dart [trials]` (default 200 trials/level)
// from the flutter/ directory. Prints a win-rate table; a level with a low
// win-rate needs its moveLimit raised (or, for a boss decay level, its
// decaySpawn max/everyTurns loosened) in lib/data/levels.dart.
//
// Same algorithm as the TS version: 1-ply-lookahead greedy bot — every turn,
// try every legal action (4 swipes, plus 1 split-tap per splittable tile
// when the level allows splitting), clone the session, apply it, score the
// result, keep the best (+ small random tie-break noise). No exhaustive
// search, no real AI — a fast, deterministic-per-seed proxy for "can a
// reasonable player clear this within moveLimit."
import 'dart:io';
import 'dart:math' as math;

import 'package:farm_merge_flutter/core/game_session.dart';
import 'package:farm_merge_flutter/core/rng.dart';
import 'package:farm_merge_flutter/core/types.dart';
import 'package:farm_merge_flutter/data/chains.dart' as chain_data;
import 'package:farm_merge_flutter/data/levels.dart' as level_data;

/// Same shape as the TS score() (sim/simulate.ts:29-39): objective progress,
/// a tile-value heuristic that rewards tiles at/under the level's highest
/// still-needed tier and penalizes hoarding tiles above it, plus a small
/// bonus for open board space. Not the real win condition — a heuristic the
/// greedy bot maximizes each turn.
double _score(GameSession s) {
  if (s.status == SessionStatus.won) return 1e6 + s.movesLeft;
  if (s.status == SessionStatus.lost) return -1e6;

  var total = 0.0;
  for (var i = 0; i < s.level.objectives.length; i++) {
    final o = s.level.objectives[i];
    final progress = s.tracker.progress[i] / o.target;
    total += 100 * progress * math.pow(2, o.tier - 1);
  }

  final maxTier = s.tracker.maxActiveTier();
  for (final t in s.board.tiles()) {
    if (maxTier == 0 || t.tier <= maxTier) {
      total += math.pow(t.tier, 2);
    } else {
      total -= 2 * math.pow(3, t.tier - maxTier);
    }
  }
  total += 3 * s.board.emptyCells().length;
  return total;
}

/// Tries every legal action from [s], returns the session after the
/// best-scoring one (ties broken by [noise]). Null only if there's truly
/// nothing to do (shouldn't happen while `status == playing`).
GameSession? _bestNext(GameSession s, Rng noise) {
  // A no-op candidate (nothing slid, nothing merged/split — moveLimit
  // untouched) always scores well on the space/tidiness terms below, since
  // it's the only way to avoid spawning a fresh low-tier tile. Scored
  // head-to-head against real moves it would win every time and the bot
  // would "pass" forever, so no-ops are only ever a fallback when literally
  // every real action is a no-op (i.e., truly stuck).
  GameSession? bestReal;
  var bestRealScore = double.negativeInfinity;
  GameSession? bestAny;
  var bestAnyScore = double.negativeInfinity;

  void consider(GameSession candidate) {
    final sc = _score(candidate) + noise.next() * 0.5;
    if (sc > bestAnyScore) {
      bestAnyScore = sc;
      bestAny = candidate;
    }
    if (candidate.movesUsed != s.movesUsed && sc > bestRealScore) {
      bestRealScore = sc;
      bestReal = candidate;
    }
  }

  for (final dir in Direction.values) {
    final clone = s.clone();
    clone.swipe(dir);
    consider(clone);
  }
  if (s.canSplit) {
    for (final t in s.board.tiles().toList()) {
      if (t.tier <= 1) continue;
      final clone = s.clone();
      clone.tap(t.row, t.col);
      consider(clone);
    }
  }
  return bestReal ?? bestAny;
}

class _Result {
  final int wins;
  final int trials;
  final List<int> winningMoves;
  _Result(this.wins, this.trials, this.winningMoves);

  double get winRate => trials == 0 ? 0 : wins / trials * 100;
  double get avgMoves => winningMoves.isEmpty ? 0 : winningMoves.reduce((a, b) => a + b) / winningMoves.length;
}

_Result _play(LevelConfig level, ChainDef chain, int trials) {
  var wins = 0;
  final winningMoves = <int>[];

  for (var seed = 1; seed <= trials; seed++) {
    var s = GameSession(level, chain, seed: seed * 7919);
    final noise = Rng(seed * 104729);
    var stallCount = 0;
    var lastMovesUsed = s.movesUsed;

    for (var turn = 0; turn < 1000 && s.status == SessionStatus.playing; turn++) {
      final next = _bestNext(s, noise);
      if (next == null) break;
      s = next;
      if (s.movesUsed == lastMovesUsed) {
        stallCount++;
        if (stallCount >= 5) break; // truly nothing left to try — treat as a loss below
      } else {
        stallCount = 0;
        lastMovesUsed = s.movesUsed;
      }
    }

    if (s.status == SessionStatus.won) {
      wins++;
      winningMoves.add(s.movesUsed);
    }
  }

  return _Result(wins, trials, winningMoves);
}

void main(List<String> args) {
  final trials = args.isNotEmpty ? int.parse(args[0]) : 200;
  stdout.writeln('Simulating ${level_data.levelList.length} levels × $trials trials (greedy bot)...\n');
  stdout.writeln('${'id'.padRight(8)}${'mode'.padRight(8)}${'moveLimit'.padRight(11)}${'winRate%'.padRight(10)}avgMoves(win)');

  for (final level in level_data.levelList) {
    final chain = chain_data.chains[level.chainId]!;
    final result = _play(level, chain, trials);
    stdout.writeln(
      '${level.id.padRight(8)}'
      '${level.mode.name.padRight(8)}'
      '${level.moveLimit.toString().padRight(11)}'
      '${result.winRate.toStringAsFixed(1).padRight(10)}'
      '${result.avgMoves.toStringAsFixed(1)}',
    );
  }
}
