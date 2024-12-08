import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  bool _isDarkTheme = false;
  String _language = 'rus';

  bool get isDarkTheme => _isDarkTheme;
  String get language => _language;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _language = prefs.getString('language') ?? 'rus';
  }

  Future<void> setDarkTheme(bool value) async {
    _isDarkTheme = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', value);
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }
}
