part of 'settings_bloc.dart';


abstract class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsLoad extends SettingsEvent {}

class SettingsChangeTheme extends SettingsEvent {
  final bool isDarkMode;

  SettingsChangeTheme({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}

class SettingsChangeLanguage extends SettingsEvent {
  final String languageCode;

  SettingsChangeLanguage({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}

class SettingsChangeNotificationLanguage extends SettingsEvent {
  final String languageCode;

  SettingsChangeNotificationLanguage({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}

class SettingsUpdated extends SettingsEvent {}
