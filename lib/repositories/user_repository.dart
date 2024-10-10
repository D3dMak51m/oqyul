import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/premium_status.dart';

class UserRepository {
  static const String _userKey = 'user_data';

  // Проверка, залогинен ли пользователь
  Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }

  // Получение текущего пользователя
  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString(_userKey);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    } else {
      throw Exception('Пользователь не найден');
    }
  }

  // Сохранение данных пользователя (имитация авторизации)
  Future<void> persistToken(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Удаление данных пользователя (выход из аккаунта)
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Регистрация нового пользователя (имитация)
  Future<User> register({
    required String fullName,
    required String carNumber,
    required String phoneNumber,
    required String password,
  }) async {
    // В реальном приложении здесь будет запрос к серверу
    // Для имитации создадим пользователя локально
    final user = User(
      id: phoneNumber, // Используем номер телефона как уникальный идентификатор
      fullName: fullName,
      carNumber: carNumber,
      phoneNumber: phoneNumber,
      password: password,
      premiumStatus: PremiumStatus(isActive: false),
    );
    await persistToken(user);
    return user;
  }
}
