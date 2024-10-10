import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';

class SettingsRepository {
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _languageCodeKey = 'language_code';
  static const String _notificationLanguageCodeKey = 'notification_language_code';

  // Получение текущих настроек
  Future<Settings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_isDarkModeKey) ?? false;
    final languageCode = prefs.getString(_languageCodeKey) ?? 'ru';
    final notificationLanguageCode = prefs.getString(_notificationLanguageCodeKey) ?? 'ru';

    return Settings(
      isDarkMode: isDarkMode,
      languageCode: languageCode,
      notificationLanguageCode: notificationLanguageCode,
    );
  }

  // Установка режима темы
  Future<void> setThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDarkMode);
  }

  // Установка языка интерфейса
  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
  }

  // Установка языка оповещений
  Future<void> setNotificationLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notificationLanguageCodeKey, languageCode);
  }
}
