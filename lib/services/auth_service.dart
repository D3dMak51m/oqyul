import 'dart:async';
import 'package:oqyul/models/premium_status.dart';

import '../models/user.dart';
// import '../models/premium_status.dart';

class AuthService {
  // Имитируем отправку OTP-кода
  Future<void> sendOtpCode(String phoneNumber) async {
    // В реальном приложении здесь будет отправка кода через SMS
    // Для имитации просто ждем 2 секунды
    await Future.delayed(Duration(seconds: 2));
  }

  // Имитируем проверку OTP-кода
  Future<bool> verifyOtpCode(String phoneNumber, String code) async {
    // В реальном приложении здесь будет проверка кода на сервере
    // Для имитации считаем, что правильный код всегда "1234"
    await Future.delayed(Duration(seconds: 1));
    return code == '1234';
  }

  // Имитируем авторизацию пользователя
  Future<User> login({required String phoneNumber, required String password}) async {
    // В реальном приложении здесь будет запрос к серверу
    await Future.delayed(Duration(seconds: 2));
    // Имитируем успешный логин
    return User(
      id: phoneNumber,
      fullName: 'Имя Пользователя',
      carNumber: 'Авто Номер',
      phoneNumber: phoneNumber,
      premiumStatus: PremiumStatus(isActive: false),
      password: password,
    );
  }

  // Имитируем регистрацию пользователя
  Future<User> register({
    required String fullName,
    required String carNumber,
    required String phoneNumber,
    required String password,
  }) async {
    // В реальном приложении здесь будет запрос к серверу
    await Future.delayed(Duration(seconds: 1));
    // Имитируем успешную регистрацию
    return User(
      id: phoneNumber,
      fullName: fullName,
      carNumber: carNumber,
      phoneNumber: phoneNumber,
      premiumStatus: PremiumStatus(isActive: false),
      password: password,
    );
  }
}
