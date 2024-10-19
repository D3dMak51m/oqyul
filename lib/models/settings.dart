// lib/models/settings.dart
/// Модель данных для пользовательских настроек приложения
class Settings {
  final String appLanguage;
  final String voiceAlertLanguage;
  final bool isDarkTheme;

  /// Конструктор класса Settings
  Settings({
    required this.appLanguage,
    required this.voiceAlertLanguage,
    required this.isDarkTheme,
  });

  /// Создание объекта Settings из JSON
  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      appLanguage: json['appLanguage'] as String,
      voiceAlertLanguage: json['voiceAlertLanguage'] as String,
      isDarkTheme: json['isDarkTheme'] as bool,
    );
  }

  /// Преобразование объекта Settings в JSON
  Map<String, dynamic> toJson() {
    return {
      'appLanguage': appLanguage,
      'voiceAlertLanguage': voiceAlertLanguage,
      'isDarkTheme': isDarkTheme,
    };
  }

  /// Копирование объекта Settings с новыми значениями
  Settings copyWith({
    String? appLanguage,
    String? voiceAlertLanguage,
    bool? isDarkTheme,
  }) {
    return Settings(
      appLanguage: appLanguage ?? this.appLanguage,
      voiceAlertLanguage: voiceAlertLanguage ?? this.voiceAlertLanguage,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
    );
  }

  @override
  String toString() {
    return 'Settings(appLanguage: $appLanguage, voiceAlertLanguage: $voiceAlertLanguage, isDarkTheme: $isDarkTheme)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Settings &&
        other.appLanguage == appLanguage &&
        other.voiceAlertLanguage == voiceAlertLanguage &&
        other.isDarkTheme == isDarkTheme;
  }

  @override
  int get hashCode {
    return appLanguage.hashCode ^ voiceAlertLanguage.hashCode ^ isDarkTheme.hashCode;
  }
}
