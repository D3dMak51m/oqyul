import 'package:flutter/material.dart';
import 'package:oqyul/screens/home/home_screen.dart';
import 'package:oqyul/screens/login/login_screen.dart';
// import '../screens/home_screen.dart';
import '../screens/registration/registration_screen.dart';
// import '../screens/registration/login_screen.dart';
import '../screens/settings/settings_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/registration':
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsScreen());
    // Добавьте другие маршруты по необходимости
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Нет маршрута для ${settings.name}')),
          ),
        );
    }
  }
}
