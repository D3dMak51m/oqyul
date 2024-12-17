import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'controllers/settings_controller.dart';
import 'services/settings_service.dart';
import 'screens/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MobileAds.instance.initialize();
  final settingsService = SettingsService();
  await settingsService.loadSettings(); // Загрузка сохранённых настроек
  final settingsController = SettingsController(settingsService: settingsService);

  runApp(MyApp(settingsController: settingsController));
}

class MyApp extends StatelessWidget {
  final SettingsController settingsController;
  const MyApp({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: settingsController,
      builder: (context, _, __) {
        return MaterialApp(
          title: 'Marker Clustering & Map Modes Example',
          themeMode: settingsController.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xff435158),
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xff435158),
              brightness: Brightness.dark,
            ),
          ),

          locale: Locale(settingsController.currentLanguage),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru'),
            Locale('en'),
          ],
          home: MapScreen(settingsController: settingsController),
        );
      },
    );
  }
}
