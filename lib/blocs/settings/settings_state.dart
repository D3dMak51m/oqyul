part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;

  SettingsLoaded({required this.settings});

  @override
  List<Object?> get props => [settings];
}

class SettingsError extends SettingsState {
  final String error;

  SettingsError({required this.error});

  @override
  List<Object?> get props => [error];
}
