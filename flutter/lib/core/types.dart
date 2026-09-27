/// Ported from src/core/types.ts. Kept as plain data classes (no codegen) so
/// the port stays a direct, line-by-line translation that's easy to diff
/// against the TypeScript source.
library;

enum Direction { up, down, left, right }

enum LevelMode { merge, split, mixed }

enum BornFrom { initial, spawn, merge, split }

enum InvalidReason { noSpace, tier1, notNeeded }

enum SessionStatus { playing, won, lost }

enum LoseReason { outOfMoves, stuck }

class Pos {
  final int row;
  final int col;
  const Pos(this.row, this.col);

  @override
  bool operator ==(Object other) => other is Pos && other.row == row && other.col == col;

  @override
  int get hashCode => Object.hash(row, col);

  @override
  String toString() => 'Pos($row, $col)';
}

class SkinDef {
  final String id;
  final String name;
  final String emoji;
  final int color;
  final num weight;
  const SkinDef({required this.id, required this.name, required this.emoji, required this.color, required this.weight});
}

class TierDef {
  final int tier;
  final String id;
  final String name;
  final String emoji;
  final int color;
  final List<SkinDef>? skins;
  const TierDef({
    required this.tier,
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    this.skins,
  });
}

class ChainDef {
  final String id;
  final String name;
  final List<TierDef> tiers;
  const ChainDef({required this.id, required this.name, required this.tiers});
}

class ObjectiveDef {
  final int tier;
  final String? skinId;
  final int target;
  const ObjectiveDef({required this.tier, this.skinId, required this.target});
}

class InitialTile {
  final int tier;
  final int? row;
  final int? col;
  const InitialTile({required this.tier, this.row, this.col});
}

class BigTileEvery {
  final int turns;
  final int tier;
  const BigTileEvery({required this.turns, required this.tier});
}

class SpawnConfig {
  final int perTurn;
  final double? doubleChance;
  final BigTileEvery? bigTileEvery;
  const SpawnConfig({required this.perTurn, this.doubleChance, this.bigTileEvery});
}

class LevelConfig {
  final String id;
  final String name;
  final String chainId;
  final LevelMode mode;
  final int rows;
  final int cols;
  final List<InitialTile>? initialTiles;
  final int? initialRandom;
  final SpawnConfig spawn;
  final List<ObjectiveDef> objectives;
  final int moveLimit;
  final (double, double)? starThresholds;
  final String producesIngredient;
  final bool boss;
  final String? hint;

  const LevelConfig({
    required this.id,
    required this.name,
    required this.chainId,
    required this.mode,
    required this.rows,
    required this.cols,
    this.initialTiles,
    this.initialRandom,
    required this.spawn,
    required this.objectives,
    required this.moveLimit,
    this.starThresholds,
    required this.producesIngredient,
    this.boss = false,
    this.hint,
  });
}

class IngredientDef {
  final String id;
  final String name;
  final String emoji;
  const IngredientDef({required this.id, required this.name, required this.emoji});
}

class RecipeDef {
  final String id;
  final String name;
  final String verb;
  final String emoji;
  final String station;
  final List<IngredientDef> ingredients;
  const RecipeDef({
    required this.id,
    required this.name,
    required this.verb,
    required this.emoji,
    required this.station,
    required this.ingredients,
  });
}

class DecorDef {
  final String id;
  final String name;
  final String emoji;
  const DecorDef({required this.id, required this.name, required this.emoji});
}

class ChapterDef {
  final String id;
  final String name;
  final RecipeDef recipe;
  final List<String> levelIds;
  final List<DecorDef> unlocks;
  const ChapterDef({
    required this.id,
    required this.name,
    required this.recipe,
    required this.levelIds,
    required this.unlocks,
  });
}

/// Mutable, unlike the rest of this file — mirrors Tile in types.ts, which the
/// TS Board also mutates in place (row/col/tier/skinId/bornFrom on split&slide).
class Tile {
  final int uid;
  int tier;
  String? skinId;
  int row;
  int col;
  BornFrom bornFrom;

  Tile({required this.uid, required this.tier, this.skinId, required this.row, required this.col, required this.bornFrom});

  Tile copy() => Tile(uid: uid, tier: tier, skinId: skinId, row: row, col: col, bornFrom: bornFrom);
}

sealed class GameEvent {
  const GameEvent();
}

class MoveEvent extends GameEvent {
  final int uid;
  final Pos to;
  const MoveEvent({required this.uid, required this.to});
}

class MergeEvent extends GameEvent {
  final int a;
  final int b;
  final Tile result;
  const MergeEvent({required this.a, required this.b, required this.result});
}

class SpawnEvent extends GameEvent {
  final Tile tile;
  const SpawnEvent({required this.tile});
}

class SplitEvent extends GameEvent {
  final Tile kept;
  final Tile spawned;
  const SplitEvent({required this.kept, required this.spawned});
}

class HarvestEvent extends GameEvent {
  final Tile tile;
  final bool auto;
  final int? objectiveIndex;
  final int coins;
  const HarvestEvent({required this.tile, required this.auto, required this.objectiveIndex, required this.coins});
}

class InvalidEvent extends GameEvent {
  final int uid;
  final InvalidReason reason;
  const InvalidEvent({required this.uid, required this.reason});
}

class NoChangeEvent extends GameEvent {
  const NoChangeEvent();
}
