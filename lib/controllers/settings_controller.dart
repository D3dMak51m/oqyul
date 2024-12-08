import 'package:flutter/foundation.dart';
import '../services/settings_service.dart';

class SettingsController extends ValueNotifier<void> {
  final SettingsService settingsService;

  SettingsController({required this.settingsService}) : super(null);

  bool get isDarkTheme => settingsService.isDarkTheme;
  String get currentLanguage => settingsService.language;

  Future<void> toggleTheme() async {
    await settingsService.setDarkTheme(!isDarkTheme);
    notifyListeners();
  }

  Future<void> changeLanguage(String lang) async {
    await settingsService.setLanguage(lang);
    notifyListeners();
  }
}
