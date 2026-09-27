import 'dart:convert';

import 'types.dart';

abstract class KeyValueStorage {
  String? getItem(String key);
  void setItem(String key, String value);
}

/// In-memory storage for tests / previews — mirrors memoryStorage() in
/// src/core/SaveManager.ts. The real app uses SharedPreferencesStorage
/// (lib/core/shared_prefs_storage.dart) instead.
class MemoryStorage implements KeyValueStorage {
  final _map = <String, String>{};

  @override
  String? getItem(String key) => _map[key];

  @override
  void setItem(String key, String value) => _map[key] = value;
}

class SaveData {
  static const version = 1;
  Map<String, int> levelStars;
  Map<String, int> inventory;
  List<String> cooked;
  List<String> decor;
  int coins;

  SaveData({Map<String, int>? levelStars, Map<String, int>? inventory, List<String>? cooked, List<String>? decor, this.coins = 0})
    : levelStars = levelStars ?? {},
      inventory = inventory ?? {},
      cooked = cooked ?? [],
      decor = decor ?? [];

  factory SaveData.empty() => SaveData();

  factory SaveData.fromJson(Map<String, dynamic> json) {
    return SaveData(
      levelStars: {
        for (final e in (json['levels'] as Map<String, dynamic>? ?? {}).entries)
          e.key: (e.value as Map<String, dynamic>)['stars'] as int,
      },
      inventory: {for (final e in (json['inventory'] as Map<String, dynamic>? ?? {}).entries) e.key: e.value as int},
      cooked: List<String>.from(json['cooked'] as List? ?? const []),
      decor: List<String>.from(json['decor'] as List? ?? const []),
      coins: json['coins'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'version': version,
    'levels': {for (final e in levelStars.entries) e.key: {'stars': e.value}},
    'inventory': inventory,
    'cooked': cooked,
    'decor': decor,
    'coins': coins,
  };
}

class RecordWinResult {
  final bool firstClear;
  final int coinsEarned;
  const RecordWinResult({required this.firstClear, required this.coinsEarned});
}

const saveKey = 'farm2048.save.v1';
const _starCoins = 10;

/// Player progress: unlocks, stars, ingredient inventory, cooking.
/// Ported from src/core/SaveManager.ts.
class SaveManager {
  final KeyValueStorage storage;
  final List<ChapterDef> chapters;
  final Map<String, LevelConfig> levels;
  late SaveData data;

  SaveManager(this.storage, this.chapters, this.levels) {
    data = _load();
  }

  bool isChapterUnlocked(String chapterId) {
    final idx = chapters.indexWhere((c) => c.id == chapterId);
    return idx == 0 || (idx > 0 && isCooked(chapters[idx - 1].id));
  }

  bool isLevelUnlocked(String levelId) {
    final chapter = chapters.where((c) => c.levelIds.contains(levelId)).firstOrNull;
    if (chapter == null || !isChapterUnlocked(chapter.id)) return false;
    final idx = chapter.levelIds.indexOf(levelId);
    return idx == 0 || isLevelCleared(chapter.levelIds[idx - 1]);
  }

  bool isLevelCleared(String levelId) => (data.levelStars[levelId] ?? 0) > 0;

  int levelStars(String levelId) => data.levelStars[levelId] ?? 0;

  bool isCooked(String chapterId) => data.cooked.contains(chapterId);

  /// Ingredients are granted only on the first clear; replays can only raise stars.
  RecordWinResult recordWin(String levelId, int stars, int levelCoins) {
    final level = levels[levelId];
    final firstClear = !isLevelCleared(levelId);
    final prevStars = levelStars(levelId);
    final bonus = stars > prevStars ? stars - prevStars : 0;
    final coinsEarned = levelCoins + bonus * _starCoins;
    if (firstClear && level != null) {
      final ing = level.producesIngredient;
      data.inventory[ing] = (data.inventory[ing] ?? 0) + 1;
    }
    data.levelStars[levelId] = prevStars > stars ? prevStars : stars;
    data.coins += coinsEarned;
    _persist();
    return RecordWinResult(firstClear: firstClear, coinsEarned: coinsEarned);
  }

  bool canCook(String chapterId) {
    final chapter = chapters.where((c) => c.id == chapterId).firstOrNull;
    if (chapter == null || isCooked(chapterId)) return false;
    return chapter.recipe.ingredients.every((i) => (data.inventory[i.id] ?? 0) >= 1);
  }

  bool cook(String chapterId) {
    final chapter = chapters.where((c) => c.id == chapterId).firstOrNull;
    if (chapter == null || !canCook(chapterId)) return false;
    for (final i in chapter.recipe.ingredients) {
      data.inventory[i.id] = (data.inventory[i.id] ?? 0) - 1;
    }
    data.cooked.add(chapterId);
    for (final d in chapter.unlocks) {
      if (!data.decor.contains(d.id)) data.decor.add(d.id);
    }
    _persist();
    return true;
  }

  void reset() {
    data = SaveData.empty();
    _persist();
  }

  SaveData _load() {
    try {
      final raw = storage.getItem(saveKey);
      if (raw == null) return SaveData.empty();
      final parsed = jsonDecode(raw) as Map<String, dynamic>;
      return parsed['version'] == 1 ? SaveData.fromJson(parsed) : SaveData.empty();
    } catch (_) {
      return SaveData.empty();
    }
  }

  void _persist() {
    try {
      storage.setItem(saveKey, jsonEncode(data.toJson()));
    } catch (_) {
      // Storage full or blocked: progress stays in memory for this session.
    }
  }
}
