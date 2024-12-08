import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

// Для time zone функционала необходимо инициализировать time zone:
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

import 'package:timezone/timezone.dart' as tz;

class PremiumService {
  bool _isPremiumActive = false;
  DateTime? _premiumEndTime;
  int _adsWatched = 0;

  bool get isPremiumActive => _isPremiumActive;
  DateTime? get premiumEndTime => _premiumEndTime;
  int get adsWatched => _adsWatched;

  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  PremiumService() {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremiumActive = prefs.getBool('isPremiumActive') ?? false;

    final endTimeStr = prefs.getString('premiumEndTime');
    if (endTimeStr != null) {
      _premiumEndTime = DateTime.tryParse(endTimeStr);
    }

    _adsWatched = prefs.getInt('adsWatched') ?? 0;

    // Инициализируем уведомления
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings darwinInit = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit, // В последних версиях можно использовать darwin вместо iOS
      // darwinInit работает и для iOS, и для macOS при необходимости
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremiumActive', _isPremiumActive);
    if (_premiumEndTime != null) {
      await prefs.setString('premiumEndTime', _premiumEndTime!.toIso8601String());
    } else {
      await prefs.remove('premiumEndTime');
    }
    await prefs.setInt('adsWatched', _adsWatched);
  }

  Future<void> incrementAdsWatched() async {
    _adsWatched++;
    await saveState();
  }

  Future<void> resetAdsWatched() async {
    _adsWatched = 0;
    await saveState();
  }

  Future<void> activatePremium() async {
    _isPremiumActive = true;
    _premiumEndTime = DateTime.now().add(const Duration(hours: 16));
    await saveState();
    await scheduleNotifications();
  }

  Future<void> extendPremium() async {
    if (!_isPremiumActive) return;
    _premiumEndTime = _premiumEndTime!.add(const Duration(hours: 3));
    await saveState();
    await scheduleNotifications();
  }

  Future<void> deactivatePremium() async {
    _isPremiumActive = false;
    _premiumEndTime = null;
    await saveState();
  }

  Future<void> scheduleNotifications() async {
    // Очистим старые уведомления
    await _notificationsPlugin.cancelAll();

    if (_isPremiumActive && _premiumEndTime != null) {
      final remaining = _premiumEndTime!.difference(DateTime.now());
      if (remaining > Duration.zero) {
        // Если остаётся больше 1 часа, запланируем уведомление на 1 час до конца
        if (remaining > const Duration(hours: 1)) {
          final notifTime = _premiumEndTime!.subtract(const Duration(hours: 1));
          await _scheduleNotification(
            id: 1,
            datetime: notifTime,
            title: 'Премиум-режим',
            body: 'Остался 1 час премиум-режима',
          );
        }
        // Уведомление об окончании
        await _scheduleNotification(
          id: 2,
          datetime: _premiumEndTime!,
          title: 'Премиум-режим',
          body: 'Премиум-режим истёк',
        );
      }
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required DateTime datetime,
    required String title,
    required String body
  }) async {
    // Для iOS (darwin) используем DarwinNotificationDetails
    const darwinDetails = DarwinNotificationDetails();

    // Android детали
    const androidDetails = AndroidNotificationDetails(
      'premium_channel',
      'Премиум',
      importance: Importance.max,
      priority: Priority.high,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails, // в новой версии параметр называется darwin
    );

    // В новых версиях zonedSchedule требует uiLocalNotificationDateInterpretation и androidScheduleMode
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _convertToTZ(datetime),
      details,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  tz.TZDateTime _convertToTZ(DateTime dt) {
    // Нужно инициализировать timeZone при запуске приложения:
    // tz.initializeTimeZones();
    // tz.setLocalLocation(tz.getLocation('Europe/Moscow')); // например
    final now = DateTime.now();
    final diff = dt.difference(now);
    return tz.TZDateTime.now(tz.local).add(diff);
  }
}
