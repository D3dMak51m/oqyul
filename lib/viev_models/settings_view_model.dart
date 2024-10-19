// lib/view_models/settings_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oqyul/viev_models/map_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';
import '../utils/constants.dart';

class SettingsViewModel extends StateNotifier<Settings> {
  final Ref _ref;  // Добавляем Ref для доступа к другим провайдерам

  SettingsViewModel(this._ref)
      : super(Settings(appLanguage: 'ru', voiceAlertLanguage: 'ru', isDarkTheme: false)) {
    _loadSettings();
  }

  /// Загрузка пользовательских настроек из SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final appLanguage = prefs.getString(SharedPreferencesKeys.appLanguage) ?? 'ru';
    final voiceAlertLanguage = prefs.getString(SharedPreferencesKeys.voiceAlertLanguage) ?? 'ru';
    final isDarkTheme = prefs.getBool(SharedPreferencesKeys.isDarkTheme) ?? false;

    state = Settings(
      appLanguage: appLanguage,
      voiceAlertLanguage: voiceAlertLanguage,
      isDarkTheme: isDarkTheme,
    );

    // После загрузки настроек обновляем стиль карты
    _ref.read(mapViewModelProvider.notifier).loadMapStyle();
  }

  /// Сохранение настроек в SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferencesKeys.appLanguage, state.appLanguage);
    await prefs.setString(SharedPreferencesKeys.voiceAlertLanguage, state.voiceAlertLanguage);
    await prefs.setBool(SharedPreferencesKeys.isDarkTheme, state.isDarkTheme);
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

  /// Переключение темы (светлая/темная) и обновление стиля карты
  Future<void> toggleTheme() async {
    state = state.copyWith(isDarkTheme: !state.isDarkTheme);
    await _saveSettings();

    // Обновляем стиль карты в зависимости от темы
    _ref.read(mapViewModelProvider.notifier).loadMapStyle();
  }
}

/// Провайдер для управления пользовательскими настройками
final settingsViewModelProvider = StateNotifierProvider<SettingsViewModel, Settings>(
      (ref) => SettingsViewModel(ref),  // Передаем ref в SettingsViewModel для доступа к другим провайдерам
);
