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

const defaultEnergyMax = 5;

class SaveData {
  static const version = 1;
  Map<String, int> levelStars;
  Map<String, int> inventory;
  List<String> cooked;
  List<String> decor;
  List<String> seenScenes;
  int coins;
  int gems;
  int energy;
  int energyMax;

  /// Epoch ms marking the last time energy regen was applied. Null means
  /// "never checked yet" — the first regen check will initialize it to now
  /// without granting a windfall of energy for a long-idle save.
  int? lastEnergyRefillMs;

  SaveData({
    Map<String, int>? levelStars,
    Map<String, int>? inventory,
    List<String>? cooked,
    List<String>? decor,
    List<String>? seenScenes,
    this.coins = 0,
    this.gems = 0,
    int? energy,
    this.energyMax = defaultEnergyMax,
    this.lastEnergyRefillMs,
  }) : levelStars = levelStars ?? {},
       inventory = inventory ?? {},
       cooked = cooked ?? [],
       decor = decor ?? [],
       seenScenes = seenScenes ?? [],
       energy = energy ?? (energyMax);

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
      seenScenes: List<String>.from(json['seenScenes'] as List? ?? const []),
      coins: json['coins'] as int? ?? 0,
      gems: json['gems'] as int? ?? 0,
      energy: json['energy'] as int?,
      energyMax: json['energyMax'] as int? ?? defaultEnergyMax,
      lastEnergyRefillMs: json['lastEnergyRefillMs'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'version': version,
    'levels': {for (final e in levelStars.entries) e.key: {'stars': e.value}},
    'inventory': inventory,
    'cooked': cooked,
    'decor': decor,
    'seenScenes': seenScenes,
    'coins': coins,
    'gems': gems,
    'energy': energy,
    'energyMax': energyMax,
    'lastEnergyRefillMs': lastEnergyRefillMs,
  };
}

class RecordWinResult {
  final bool firstClear;
  final int coinsEarned;
  const RecordWinResult({required this.firstClear, required this.coinsEarned});
}

const saveKey = 'farm2048.save.v1';
const _starCoins = 10;

/// One energy point regenerates every 20 minutes, up to energyMax. Tunable —
/// no game-design sign-off yet on the exact pacing, this is a placeholder.
const energyRegenInterval = Duration(minutes: 20);

/// Player progress: unlocks, stars, ingredient inventory, cooking, and the
/// economy layer (coins, gems, energy). Ported from src/core/SaveManager.ts,
/// extended with gems/energy which have no TS/web equivalent yet.
class SaveManager {
  final KeyValueStorage storage;
  final List<ChapterDef> chapters;
  final Map<String, LevelConfig> levels;

  /// Injectable clock so energy regen is deterministic in tests.
  final int Function() now;

  late SaveData data;

  SaveManager(this.storage, this.chapters, this.levels, {int Function()? now})
    : now = now ?? (() => DateTime.now().millisecondsSinceEpoch) {
    data = _load();
    _regenEnergy();
  }

  // --- Economy: coins / gems ------------------------------------------

  bool spendCoins(int amount) {
    if (data.coins < amount) return false;
    data.coins -= amount;
    _persist();
    return true;
  }

  void addGems(int amount) {
    data.gems += amount;
    _persist();
  }

  /// Credits coins directly — used today only by [ShopDialog]'s simulated
  /// purchase buttons (lib/widgets/shop_dialog.dart). When a real payment
  /// gateway/IAP is wired in, its purchase-success callback should call this
  /// (after verifying the receipt), not the UI layer.
  void addCoins(int amount) {
    data.coins += amount;
    _persist();
  }

  bool spendGems(int amount) {
    if (data.gems < amount) return false;
    data.gems -= amount;
    _persist();
    return true;
  }

  // --- Economy: energy ---------------------------------------------------

  int get energy {
    _regenEnergy();
    return data.energy;
  }

  int get energyMax => data.energyMax;

  bool get hasEnergy => energy > 0;

  /// Time remaining until the next energy point, or Duration.zero when full.
  Duration get timeUntilNextEnergy {
    _regenEnergy();
    if (data.energy >= data.energyMax) return Duration.zero;
    final elapsed = now() - (data.lastEnergyRefillMs ?? now());
    final remaining = energyRegenInterval.inMilliseconds - elapsed;
    return Duration(milliseconds: remaining < 0 ? 0 : remaining);
  }

  bool spendEnergy() {
    _regenEnergy();
    if (data.energy <= 0) return false;
    data.energy--;
    _persist();
    return true;
  }

  /// Instantly fill energy for gems. Returns false if not enough gems.
  bool refillEnergyWithGems({int gemCost = 20}) {
    if (!spendGems(gemCost)) return false;
    data.energy = data.energyMax;
    data.lastEnergyRefillMs = now();
    _persist();
    return true;
  }

  void _regenEnergy() {
    final t = now();
    if (data.lastEnergyRefillMs == null) {
      data.lastEnergyRefillMs = t;
      return;
    }
    if (data.energy >= data.energyMax) {
      data.lastEnergyRefillMs = t;
      return;
    }
    final elapsed = t - data.lastEnergyRefillMs!;
    final ticks = elapsed ~/ energyRegenInterval.inMilliseconds;
    if (ticks <= 0) return;
    final grown = data.energy + ticks;
    data.energy = grown > data.energyMax ? data.energyMax : grown;
    data.lastEnergyRefillMs = data.lastEnergyRefillMs! + ticks * energyRegenInterval.inMilliseconds;
    _persist();
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

  /// A property (lib/data/properties.dart) unlocks exactly when its first
  /// chapter does — its chapters are a contiguous slice of the same flat
  /// `chapters` list [isChapterUnlocked] already sequences, so no new state.
  bool isPropertyUnlocked(PropertyDef property) => isChapterUnlocked(property.chapterIds.first);

  bool isPropertyDone(PropertyDef property) => property.chapterIds.every(isCooked);

  bool hasSeenScene(String sceneId) => data.seenScenes.contains(sceneId);

  void markSceneSeen(String sceneId) {
    if (data.seenScenes.contains(sceneId)) return;
    data.seenScenes.add(sceneId);
    _persist();
  }

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
