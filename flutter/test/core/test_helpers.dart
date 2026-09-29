import 'package:farm_merge_flutter/core/game_session.dart';
import 'package:farm_merge_flutter/core/types.dart';

/// Mirrors tests/core/helpers.ts.
const testChain = ChainDef(
  id: 'test',
  name: 'Test',
  tiers: [
    TierDef(tier: 1, id: 't1', name: 'T1', emoji: '', color: 0),
    TierDef(tier: 2, id: 't2', name: 'T2', emoji: '', color: 0),
    TierDef(tier: 3, id: 't3', name: 'T3', emoji: '', color: 0),
    TierDef(tier: 4, id: 't4', name: 'T4', emoji: '', color: 0),
  ],
);

LevelConfig makeLevel({
  int rows = 4,
  int cols = 4,
  LevelMode mode = LevelMode.merge,
  List<InitialTile>? initialTiles,
  int? initialRandom = 0,
  SpawnConfig spawn = const SpawnConfig(perTurn: 0),
  List<ObjectiveDef> objectives = const [ObjectiveDef(tier: 3, target: 1)],
  int moveLimit = 20,
  DecaySpawnConfig? decaySpawn,
}) {
  return LevelConfig(
    id: 'test',
    name: 'Test',
    chainId: 'test',
    mode: mode,
    rows: rows,
    cols: cols,
    initialTiles: initialTiles,
    initialRandom: initialRandom,
    spawn: spawn,
    objectives: objectives,
    moveLimit: moveLimit,
    producesIngredient: 'x',
    decaySpawn: decaySpawn,
  );
}

/// Session with an exact layout: rows of tiers, 0 = empty. Mirrors sessionWith().
GameSession sessionWith(
  List<List<int>> layout, {
  LevelMode mode = LevelMode.merge,
  SpawnConfig spawn = const SpawnConfig(perTurn: 0),
  List<ObjectiveDef> objectives = const [ObjectiveDef(tier: 3, target: 1)],
  int moveLimit = 20,
  DecaySpawnConfig? decaySpawn,
}) {
  final initialTiles = <InitialTile>[
    for (var row = 0; row < layout.length; row++)
      for (var col = 0; col < layout[row].length; col++)
        if (layout[row][col] > 0) InitialTile(tier: layout[row][col], row: row, col: col),
  ];
  final level = makeLevel(
    rows: layout.length,
    cols: layout[0].length,
    mode: mode,
    initialTiles: initialTiles,
    spawn: spawn,
    objectives: objectives,
    moveLimit: moveLimit,
    decaySpawn: decaySpawn,
  );
  return GameSession(level, testChain, seed: 42);
}

List<List<int>> tiersGrid(GameSession s) {
  return [
    for (var row = 0; row < s.level.rows; row++)
      [for (var col = 0; col < s.level.cols; col++) s.board.get(row, col)?.tier ?? 0],
  ];
}
