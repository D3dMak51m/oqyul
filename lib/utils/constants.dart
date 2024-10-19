// lib/utils/constants.dart

import 'package:flutter/material.dart';

/// Константы API
class ApiConstants {
  static const String baseUrl = 'http://194.135.36.43:5000';
  static const String nearbyMarkersEndpoint = '/api/camera/nearby';
  static String getNearbyMarkersUrl(double latitude, double longitude, {int maxDistance = 10000}) {
    return '$baseUrl$nearbyMarkersEndpoint?latitude=$latitude&longitude=$longitude&maxDistance=$maxDistance';
  }
}

/// Константы для хранения ключей в SharedPreferences
class SharedPreferencesKeys {
  static const String isActive = 'isActive';
  static const String expirationTime = 'expirationTime';
  static const String remainingAdViews = 'remainingAdViews';
  static const String appLanguage = 'appLanguage';
  static const String voiceAlertLanguage = 'voiceAlertLanguage';
  static const String isDarkTheme = 'isDarkTheme';
}

/// Константы для тем приложения
class ThemeConstants {
  static const Color lightPrimaryColor = Colors.blue;
  static const Color darkPrimaryColor = Colors.blueAccent;
  static const Color lightBackgroundColor = Colors.white;
  static const Color darkBackgroundColor = Colors.black;
}

/// Константы приложения
class AppConstants {
  static const int premiumActivationAdCount = 5;  // Количество просмотров рекламы для активации премиума
  static const Duration premiumActivationDuration = Duration(hours: 16);
  static const Duration premiumExtensionDuration = Duration(hours: 3);
  static const Duration markerUpdateInterval = Duration(minutes: 10);
  static const int markerAlertIntervalSeconds = 45;
  static const double defaultMapZoom = 17.0;
  static const double driveModeMapZoom = 18.5;
  static const double driveModeTilt = 55.0;
  static const double defaultTilt = 0.0;
  static const double minZoomForMarkerIcons = 13.0;
}

/// Константы для AdMob (замените идентификаторы на реальные)
class AdMobConstants {
  static const String interstitialAdUnitId = '<YOUR_INTERSTITIAL_AD_UNIT_ID>';
  static const String bannerAdUnitId = '<YOUR_BANNER_AD_UNIT_ID>';
}
