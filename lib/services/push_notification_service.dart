// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class PushNotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//
//   Future<void> initialize() async {
//     // Запрос разрешения на получение уведомлений
//     NotificationSettings settings = await _fcm.requestPermission();
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('Пользователь разрешил уведомления');
//     } else {
//       print('Пользователь не разрешил уведомления');
//     }
//
//     // Обработка сообщений, когда приложение в фоне или закрыто
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Сообщение открыто: ${message.notification?.title}');
//       // Обработка уведомления
//     });
//
//     // Обработка сообщений, когда приложение на переднем плане
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Получено сообщение: ${message.notification?.title}');
//       // Обработка уведомления
//     });
//
//     // Получение токена устройства для отправки push-уведомлений
//     String? token = await _fcm.getToken();
//     print('FCM Token: $token');
//   }
// }
