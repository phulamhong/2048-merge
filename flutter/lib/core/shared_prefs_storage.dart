import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'save_manager.dart';

/// KeyValueStorage backed by shared_preferences. `SharedPreferences.getInstance()`
/// caches all values in memory on first load, so getItem/setItem below can stay
/// synchronous (matching the localStorage-shaped KeyValueStorage interface) —
/// setItem writes through to disk in the background without awaiting.
class SharedPrefsStorage implements KeyValueStorage {
  final SharedPreferences _prefs;
  const SharedPrefsStorage(this._prefs);

  static Future<SharedPrefsStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsStorage(prefs);
  }

  @override
  String? getItem(String key) => _prefs.getString(key);

  @override
  void setItem(String key, String value) {
    unawaited(_prefs.setString(key, value));
  }
}
