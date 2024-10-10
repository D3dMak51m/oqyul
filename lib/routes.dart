import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/registration/registration_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/registration/otp_verification_screen.dart';
import 'models/otp_arguments.dart';

class Routes {
  static const String home = '/home';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String otpVerification = '/otp_verification';
  static const String settings = '/settings';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => HomeScreen(),
    login: (context) => LoginScreen(),
    registration: (context) => RegistrationScreen(),
    otpVerification: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as OTPArguments;
      return OTPVerificationScreen(
        phoneNumber: args.phoneNumber,
        fullName: args.fullName,
        carNumber: args.carNumber,
        password: args.password,
      );
    },
    settings: (context) => SettingsScreen(),
  };
}
