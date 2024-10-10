class Settings {
  final bool isDarkMode;
  final String languageCode;
  final String notificationLanguageCode;

  Settings({
    required this.isDarkMode,
    required this.languageCode,
    required this.notificationLanguageCode,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      isDarkMode: json['isDarkMode'] as bool,
      languageCode: json['languageCode'] as String,
      notificationLanguageCode: json['notificationLanguageCode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'languageCode': languageCode,
      'notificationLanguageCode': notificationLanguageCode,
    };
  }
}
