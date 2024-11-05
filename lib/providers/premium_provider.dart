// premium_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/premium.dart';
import 'marker_provider.dart'; // Импорт для обновления маркеров

class PremiumNotifier extends StateNotifier<PremiumStatus> {
  final Ref _ref;
  Timer? _premiumUpdateTimer;

  PremiumNotifier(this._ref)
      : super(PremiumStatus(isActive: false, expirationTime: null, remainingAdViews: 5)) {
    _loadPremiumStatus();
  }

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

    if (state.isPremiumValid) {
      _startPremiumMarkerUpdate(); // Запуск таймера обновления маркеров каждые 10 минут
      _ref.read(markerProvider.notifier).refreshMarkersFromAPI(); // Загрузка маркеров из API
    }
  }

  Future<void> _savePremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isActive', state.isActive);
    await prefs.setString('expirationTime', state.expirationTime?.toIso8601String() ?? '');
    await prefs.setInt('remainingAdViews', state.remainingAdViews);
  }

  Future<void> activatePremium() async {
    final newExpirationTime = DateTime.now().add(Duration(hours: 16));
    state = state.copyWith(isActive: true, expirationTime: newExpirationTime, remainingAdViews: 0);
    await _savePremiumStatus();

    _ref.read(markerProvider.notifier).refreshMarkersFromAPI();
    _startPremiumMarkerUpdate();
  }

  Future<void> extendPremium() async {
    if (state.isPremiumValid) {
      final newExpirationTime = state.expirationTime?.add(Duration(hours: 3));
      state = state.copyWith(expirationTime: newExpirationTime);
      await _savePremiumStatus();

      _ref.read(markerProvider.notifier).refreshMarkersFromAPI();
      _startPremiumMarkerUpdate();
    }
  }

  void _startPremiumMarkerUpdate() {
    _premiumUpdateTimer?.cancel();
    _premiumUpdateTimer = Timer.periodic(Duration(minutes: 10), (timer) {
      if (state.isPremiumValid) {
        _ref.read(markerProvider.notifier).refreshMarkersFromAPI();
      } else {
        timer.cancel(); // Останавливаем таймер, если премиум истек
      }
    });
  }

  @override
  void dispose() {
    _premiumUpdateTimer?.cancel();
    super.dispose();
  }

  bool get isPremiumValid => state.isPremiumValid;
}

final premiumProvider = StateNotifierProvider<PremiumNotifier, PremiumStatus>(
      (ref) => PremiumNotifier(ref),
);
