// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oqyul/widgets/my_location_button.dart';
import 'package:oqyul/widgets/settings_button.dart';
import '../widgets/map_widget.dart';
import '../widgets/premium_button.dart';
import '../widgets/map_mode_button.dart';
import '../widgets/voice_alert_button.dart';

class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: SettingsButton(),
        actions: [
          PremiumButton(),  // Кнопка управления премиум-режимом
        ],
      ),
      body: Stack(
        children: [
          MapWidget(),  // Виджет карты Google Maps
          Positioned(
            bottom: 80,
            left: 16,
            child: VoiceAlertButton(),  // Кнопка голосового оповещения
          ),
          Positioned(
            bottom: 80,
            right: 16,
            child: MapModeButton(),  // Кнопка переключения режима карты
          ),
          Positioned(
            bottom: 80,
            right: 16,
            child: MyLocationButton(),  // Кнопка переключения режима карты
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
