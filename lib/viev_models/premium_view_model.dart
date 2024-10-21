// lib/view_models/premium_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../models/premium.dart';
import '../services/ads_service.dart';
import '../utils/constants.dart';

class PremiumViewModel extends StateNotifier<PremiumStatus> {
  final AdsService _adsService;
  Timer? _expirationTimer;

  PremiumViewModel(this._adsService)
      : super(PremiumStatus(isActive: false, expirationTime: null, remainingAdViews: AppConstants.premiumActivationAdCount)) {
    _loadPremiumStatus();
  }

  Future<void> _loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isActive = prefs.getBool(SharedPreferencesKeys.isActive) ?? false;
    final expirationTimeString = prefs.getString(SharedPreferencesKeys.expirationTime);
    final remainingAdViews = prefs.getInt(SharedPreferencesKeys.remainingAdViews) ?? AppConstants.premiumActivationAdCount;

    DateTime? expirationTime;
    if (expirationTimeString != null) {
      expirationTime = DateTime.tryParse(expirationTimeString);
    }

    if (expirationTime != null && expirationTime.isBefore(DateTime.now())) {
      state = PremiumStatus(
        isActive: false,
        expirationTime: null,
        remainingAdViews: AppConstants.premiumActivationAdCount,
      );
      await _savePremiumStatus();
    } else {
      state = PremiumStatus(
        isActive: isActive,
        expirationTime: expirationTime,
        remainingAdViews: remainingAdViews,
      );
    }

    _startExpirationTimer();
  }

  Future<void> _savePremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferencesKeys.isActive, state.isActive);
    await prefs.setString(SharedPreferencesKeys.expirationTime, state.expirationTime?.toIso8601String() ?? '');
    await prefs.setInt(SharedPreferencesKeys.remainingAdViews, state.remainingAdViews);
  }

  void _startExpirationTimer() {
    _expirationTimer?.cancel();
    if (state.isPremiumValid && state.expirationTime != null) {
      final duration = state.expirationTime!.difference(DateTime.now());
      _expirationTimer = Timer(duration, () {
        state = state.copyWith(
          isActive: false,
          expirationTime: null,
          remainingAdViews: AppConstants.premiumActivationAdCount,
        );
        _savePremiumStatus();
      });
    }
  }

  Future<void> activatePremium() async {
    final newExpirationTime = DateTime.now().add(AppConstants.premiumActivationDuration);
    state = state.copyWith(
      isActive: true,
      expirationTime: newExpirationTime,
      remainingAdViews: 0,
    );
    await _savePremiumStatus();
    _startExpirationTimer();
  }

  Future<void> extendPremium() async {
    if (state.isPremiumValid) {
      final newExpirationTime = state.expirationTime!.add(AppConstants.premiumExtensionDuration);
      state = state.copyWith(expirationTime: newExpirationTime);
      await _savePremiumStatus();
      _startExpirationTimer();
    }
  }

  Future<void> incrementAdViews() async {
    if (state.remainingAdViews > 0) {
      final newAdViews = state.remainingAdViews - 1;
      state = state.copyWith(remainingAdViews: newAdViews);
      if (newAdViews <= 0) {
        await activatePremium();
      } else {
        await _savePremiumStatus();
      }
    } else {
      await activatePremium();
    }
  }

  void showAdForPremium({bool extend = false}) {
    _adsService.showInterstitialAd(onAdClosed: () async {
      if (extend) {
        await extendPremium();
      } else {
        await incrementAdViews();
      }
    });
  }

  @override
  void dispose() {
    _expirationTimer?.cancel();
    super.dispose();
  }
}

final premiumViewModelProvider = StateNotifierProvider<PremiumViewModel, PremiumStatus>(
      (ref) => PremiumViewModel(ref.read(adsServiceProvider)),
);
