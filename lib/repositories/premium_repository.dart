import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/premium_status.dart';

class PremiumRepository {
  static const String _premiumKey = 'premium_status';

  // Получение текущего статуса премиум-режима
  Future<PremiumStatus> getPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? premiumData = prefs.getString(_premiumKey);
    if (premiumData != null) {
      return PremiumStatus.fromJson(jsonDecode(premiumData));
    } else {
      return PremiumStatus(isActive: false, adsWatched: 0);
    }
  }

  // Активация премиум-режима
  Future<void> activatePremium() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryDate = DateTime.now().add(Duration(hours: 24));
    final status = PremiumStatus(isActive: true, expiryDate: expiryDate, adsWatched: 0);
    await prefs.setString(_premiumKey, jsonEncode(status.toJson()));
  }

  // Деактивация премиум-режима
  Future<void> expirePremium() async {
    final prefs = await SharedPreferences.getInstance();
    final status = PremiumStatus(isActive: false, adsWatched: 0);
    await prefs.setString(_premiumKey, jsonEncode(status.toJson()));
  }

  // Увеличение счетчика просмотренных реклам
  Future<int> incrementAdsWatched() async {
    final prefs = await SharedPreferences.getInstance();
    final status = await getPremiumStatus();
    final updatedStatus = PremiumStatus(
      isActive: status.isActive,
      expiryDate: status.expiryDate,
      adsWatched: status.adsWatched + 1,
    );
    await prefs.setString(_premiumKey, jsonEncode(updatedStatus.toJson()));
    return updatedStatus.adsWatched;
  }

  // Продление премиум режима на указанное количество часов
  Future<void> extendPremiumByHours(int hours) async {
    final prefs = await SharedPreferences.getInstance();
    final status = await getPremiumStatus();
    DateTime newExpiryDate;

    if (status.expiryDate != null && status.expiryDate!.isAfter(DateTime.now())) {
      // Премиум активен, продлеваем от текущей даты окончания
      newExpiryDate = status.expiryDate!.add(Duration(hours: hours));
    } else {
      // Премиум не активен, устанавливаем новую дату окончания от текущего времени
      newExpiryDate = DateTime.now().add(Duration(hours: hours));
    }

    // Обновляем статус премиум режима с новой датой окончания
    final updatedStatus = PremiumStatus(
      isActive: true,
      expiryDate: newExpiryDate,
      adsWatched: 0, // Сбрасываем счетчик просмотренных реклам, если необходимо
    );

    // Сохраняем новый статус
    await prefs.setString(_premiumKey, jsonEncode(updatedStatus.toJson()));
  }
}
