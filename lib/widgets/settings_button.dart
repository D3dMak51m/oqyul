// lib/widgets/settings_button.dart

import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        // Переход на экран настроек
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        );
      },
    );
  }
}
