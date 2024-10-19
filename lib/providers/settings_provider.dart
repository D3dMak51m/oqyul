// lib/providers/settings_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';

/// Провайдер для управления пользовательскими настройками
class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings(appLanguage: 'ru', voiceAlertLanguage: 'ru', isDarkTheme: false)) {
    _loadSettings();
  }

  /// Загрузка настроек из локального хранилища
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final appLanguage = prefs.getString('appLanguage') ?? 'ru';
    final voiceAlertLanguage = prefs.getString('voiceAlertLanguage') ?? 'ru';
    final isDarkTheme = prefs.getBool('isDarkTheme') ?? false;

    state = Settings(
      appLanguage: appLanguage,
      voiceAlertLanguage: voiceAlertLanguage,
      isDarkTheme: isDarkTheme,
    );
  }

  /// Сохранение текущих настроек в локальное хранилище
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appLanguage', state.appLanguage);
    await prefs.setString('voiceAlertLanguage', state.voiceAlertLanguage);
    await prefs.setBool('isDarkTheme', state.isDarkTheme);
  }

  /// Установка нового языка интерфейса
  Future<void> setAppLanguage(String language) async {
    state = state.copyWith(appLanguage: language);
    await _saveSettings();
  }

  /// Установка нового языка для голосовых оповещений
  Future<void> setVoiceAlertLanguage(String language) async {
    state = state.copyWith(voiceAlertLanguage: language);
    await _saveSettings();
  }

  /// Переключение темы (светлая или темная)
  Future<void> toggleTheme() async {
    state = state.copyWith(isDarkTheme: !state.isDarkTheme);
    await _saveSettings();
  }
}

/// Провайдер для доступа к настройкам
final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
      (ref) => SettingsNotifier(),
);
