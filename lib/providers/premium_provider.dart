// lib/providers/premium_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/premium.dart';
import 'marker_provider.dart';  // Импорт для обновления маркеров

/// Класс для управления состоянием премиум-режима
class PremiumNotifier extends StateNotifier<PremiumStatus> {
  final Ref _ref;

  PremiumNotifier(this._ref)
      : super(PremiumStatus(isActive: false, expirationTime: null, remainingAdViews: 5)) {
    _loadPremiumStatus();
  }

  /// Загрузка состояния премиум-режима из локального хранилища
  Future<void> _loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isActive = prefs.getBool('isActive') ?? false;
    final expirationTimeString = prefs.getString('expirationTime');
    final remainingAdViews = prefs.getInt('remainingAdViews') ?? 5;

    DateTime? expirationTime;
    if (expirationTimeString != null) {
      expirationTime = DateTime.tryParse(expirationTimeString);
    }

    state = PremiumStatus(
      isActive: isActive,
      expirationTime: expirationTime,
      remainingAdViews: remainingAdViews,
    );

    // После загрузки премиум-режима обновляем маркеры
    _ref.read(markerProvider.notifier).refreshMarkers();
  }

  /// Сохранение состояния премиум-режима в локальное хранилище
  Future<void> _savePremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isActive', state.isActive);
    await prefs.setString('expirationTime', state.expirationTime?.toIso8601String() ?? '');
    await prefs.setInt('remainingAdViews', state.remainingAdViews);
  }

  /// Активация премиум-режима на 16 часов
  Future<void> activatePremium() async {
    final newExpirationTime = DateTime.now().add(Duration(hours: 16));
    state = state.copyWith(isActive: true, expirationTime: newExpirationTime, remainingAdViews: 0);
    await _savePremiumStatus();

    // После активации премиум-режима обновляем маркеры
    _ref.read(markerProvider.notifier).refreshMarkersFromAPI();
  }

  /// Продление премиум-режима на 3 часа
  Future<void> extendPremium() async {
    if (state.isPremiumValid) {
      final newExpirationTime = state.expirationTime?.add(Duration(hours: 3));
      state = state.copyWith(expirationTime: newExpirationTime);
      await _savePremiumStatus();

      // Обновляем маркеры после продления премиума
      _ref.read(markerProvider.notifier).refreshMarkersFromAPI();
    }
  }

  /// Увеличение счетчика оставшихся просмотров для активации премиума
  Future<void> incrementAdViews() async {
    if (state.remainingAdViews > 0) {
      state = state.copyWith(remainingAdViews: state.remainingAdViews - 1);
      if (state.remainingAdViews - 1 <= 0) {
        await activatePremium();
      } else {
        await _savePremiumStatus();
      }
    }
  }

  /// Проверка, действителен ли текущий премиум-режим
  bool get isPremiumValid => state.isPremiumValid;
}

/// Провайдер премиум-режима с использованием RiverPod
final premiumProvider = StateNotifierProvider<PremiumNotifier, PremiumStatus>(
      (ref) => PremiumNotifier(ref),
);
