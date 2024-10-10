class Constants {
  // URL для API
  static const String apiUrl = 'http://194.135.36.43:5000/api';

  // Настройки карты
  static const double defaultZoom = 17.0;
  static const double drivingModeZoom = 18.5;
  static const double defaultTilt = 0.0;
  static const double drivingModeTilt = 55.0;

  // Интервалы обновления
  static const Duration markerUpdateInterval = Duration(minutes: 10);
  static const Duration premiumDuration = Duration(hours: 24);

  // Премиум
  static const int adsRequiredForPremium = 6;

  // Расстояние для уведомлений
  static const double notificationDistanceMin = 150.0; // метров
  static const double notificationDistanceMax = 500.0; // метров
}
