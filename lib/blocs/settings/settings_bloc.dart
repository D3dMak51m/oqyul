import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oqyul/models/settings.dart';
import 'package:oqyul/repositories/settings_repository.dart';
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc({required this.settingsRepository}) : super(SettingsInitial()) {
    on<SettingsLoad>(_onLoadSettings);
    on<SettingsChangeTheme>(_onChangeTheme);
    on<SettingsChangeLanguage>(_onChangeLanguage);
    on<SettingsChangeNotificationLanguage>(_onChangeNotificationLanguage);
    on<SettingsUpdated>(_onSettingsUpdated);
  }

  void _onLoadSettings(SettingsLoad event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final settings = await settingsRepository.getSettings();
    emit(SettingsLoaded(settings: settings));
  }

  void _onChangeTheme(SettingsChangeTheme event, Emitter<SettingsState> emit) async {
    await settingsRepository.setThemeMode(event.isDarkMode);
    add(SettingsUpdated());
  }

  void _onChangeLanguage(SettingsChangeLanguage event, Emitter<SettingsState> emit) async {
    await settingsRepository.setLanguage(event.languageCode);
    add(SettingsUpdated());
  }

  void _onChangeNotificationLanguage(SettingsChangeNotificationLanguage event, Emitter<SettingsState> emit) async {
    await settingsRepository.setNotificationLanguage(event.languageCode);
    add(SettingsUpdated());
  }

  void _onSettingsUpdated(SettingsUpdated event, Emitter<SettingsState> emit) async {
    final settings = await settingsRepository.getSettings();
    emit(SettingsLoaded(settings: settings));
  }
}