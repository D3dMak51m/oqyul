// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oqyul/viev_models/settings_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsViewModel = ref.read(settingsViewModelProvider.notifier);
    final settings = ref.watch(settingsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Язык приложения', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: settings.appLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  settingsViewModel.setAppLanguage(newValue);
                }
              },
              items: <String>['ru', 'uz', 'en']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(_getLanguageName(value)),
                );
              }).toList(),
            ),
            SizedBox(height: 24),
            Text('Язык голосовых оповещений', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: settings.voiceAlertLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  settingsViewModel.setVoiceAlertLanguage(newValue);
                }
              },
              items: <String>['ru', 'uz', 'en']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(_getLanguageName(value)),
                );
              }).toList(),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Тема', style: TextStyle(fontSize: 18)),
                Switch(
                  value: settings.isDarkTheme,
                  onChanged: (bool newValue) {
                    settingsViewModel.toggleTheme();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Преобразует код языка в его название для отображения
  String _getLanguageName(String code) {
    switch (code) {
      case 'ru':
        return 'Русский';
      case 'uz':
        return 'Узбекский';
      case 'en':
      default:
        return 'Английский';
    }
  }
}
