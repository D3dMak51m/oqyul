import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oqyul/utils/localization/app_localizations.dart';
import 'package:oqyul/utils/localization/supported_locales.dart';
import 'utils/themes.dart';
import 'routes.dart';
import 'blocs/authentication/auth_bloc.dart';
import 'blocs/settings/settings_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'utils/navigation_service.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            return MaterialApp(
              navigatorKey: NavigationService.navigatorKey,
              title: 'Oqyul',
              debugShowCheckedModeBanner: false,
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: settingsState is SettingsLoaded && settingsState.settings.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
              supportedLocales: SupportedLocales.locales,
              localizationsDelegates: [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                // Выбор языка из настроек
                if (settingsState is SettingsLoaded) {
                  return Locale(settingsState.settings.languageCode);
                }
                return locale;
              },
              initialRoute: authState is AuthAuthenticated ? Routes.home : Routes.login,
              routes: Routes.routes,
            );
          },
        );
      },
    );
  }
}
