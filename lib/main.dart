// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'blocs/authentication/auth_bloc.dart';
import 'blocs/premium/premium_bloc.dart';
import 'blocs/map/map_bloc.dart';
import 'blocs/settings/settings_bloc.dart';
import 'blocs/voice_notification/voice_bloc.dart';
import 'repositories/user_repository.dart';
import 'repositories/premium_repository.dart';
import 'repositories/marker_repository.dart';
import 'repositories/settings_repository.dart';
import 'services/notification_service.dart';
import 'services/ad_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
  // Инициализация сервисов
  final AdService adService = AdService();
  await adService.initialize();
  // await PushNotificationService().initialize();
  final NotificationService notificationService = NotificationService();

  // Создание репозиториев
  final UserRepository userRepository = UserRepository();
  final PremiumRepository premiumRepository = PremiumRepository();
  final MarkerRepository markerRepository = MarkerRepository();
  final SettingsRepository settingsRepository = SettingsRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AdService>.value(value: adService),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(userRepository: userRepository)..add(AuthStarted()),
        ),
        BlocProvider<PremiumBloc>(
          create: (context) => PremiumBloc(premiumRepository: premiumRepository)..add(PremiumCheckStatus()),
        ),
        BlocProvider<MapBloc>(
          create: (context) => MapBloc(
            markerRepository: markerRepository,
            premiumBloc: BlocProvider.of<PremiumBloc>(context),
          ),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(settingsRepository: settingsRepository)..add(SettingsLoad()),
        ),
        BlocProvider<VoiceBloc>(
          create: (context) => VoiceBloc(notificationService: notificationService),
        ),
      ],
      child: MyApp(),
    ),
  );
}
