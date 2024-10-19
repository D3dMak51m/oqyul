// lib/data/local_storage.dart

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences _prefs;

  LocalStorage._(this._prefs);

  /// Метод для инициализации SharedPreferences
  static Future<LocalStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorage._(prefs);
  }

  /// Сохранение значения типа String
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  /// Извлечение значения типа String
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Сохранение значения типа int
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  /// Извлечение значения типа int
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Сохранение значения типа bool
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  /// Извлечение значения типа bool
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Сохранение списка строк (List<String>)
  Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  /// Извлечение списка строк (List<String>)
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  /// Удаление значения по ключу
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// Очистка всех сохраненных данных
  Future<void> clear() async {
    await _prefs.clear();
  }
}
