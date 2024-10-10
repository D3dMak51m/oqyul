// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.
// @dart=2.12
// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String? MessageIfAbsent(
    String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'ru';

  static m0(phoneNumber) => "Введите код, отправленный на номер ${phoneNumber}";

  static m1(time) => "Премиум истечет через ${time}";

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
      'appName': MessageLookupByLibrary.simpleMessage('Oqyul'),
    'cancel': MessageLookupByLibrary.simpleMessage('Отмена'),
    'carNumber': MessageLookupByLibrary.simpleMessage('Номер автомобиля'),
    'codeResent': MessageLookupByLibrary.simpleMessage('Код отправлен повторно.'),
    'confirmPassword': MessageLookupByLibrary.simpleMessage('Подтвердите пароль'),
    'darkMode': MessageLookupByLibrary.simpleMessage('Темная тема'),
    'databaseUpdated': MessageLookupByLibrary.simpleMessage('База данных успешно обновлена'),
    'disableDrivingMode': MessageLookupByLibrary.simpleMessage('Выключить режим вождения'),
    'disableSound': MessageLookupByLibrary.simpleMessage('Выключить звук'),
    'enableDrivingMode': MessageLookupByLibrary.simpleMessage('Включить режим вождения'),
    'enableSound': MessageLookupByLibrary.simpleMessage('Включить звук'),
    'error': MessageLookupByLibrary.simpleMessage('Ошибка'),
    'errorLoadingMap': MessageLookupByLibrary.simpleMessage('Ошибка загрузки карты'),
    'errorLoadingSettings': MessageLookupByLibrary.simpleMessage('Ошибка загрузки настроек'),
    'errorLoadingUserData': MessageLookupByLibrary.simpleMessage('Ошибка загрузки данных пользователя'),
    'forgotPassword': MessageLookupByLibrary.simpleMessage('Забыли пароль?'),
    'fullName': MessageLookupByLibrary.simpleMessage('ФИО'),
    'homeTitle': MessageLookupByLibrary.simpleMessage('Главная'),
    'invalidCarNumber': MessageLookupByLibrary.simpleMessage('Введите номер автомобиля'),
    'invalidFullName': MessageLookupByLibrary.simpleMessage('Введите полное имя'),
    'invalidOtp': MessageLookupByLibrary.simpleMessage('Неверный код. Попробуйте снова.'),
    'invalidPassword': MessageLookupByLibrary.simpleMessage('Пароль должен быть не менее 6 символов'),
    'invalidPhoneNumber': MessageLookupByLibrary.simpleMessage('Некорректный номер телефона'),
    'language': MessageLookupByLibrary.simpleMessage('Язык интерфейса'),
    'languageEnglish': MessageLookupByLibrary.simpleMessage('English'),
    'languageRussian': MessageLookupByLibrary.simpleMessage('Русский'),
    'languageUzbek': MessageLookupByLibrary.simpleMessage('Oʻzbekcha'),
    'loading': MessageLookupByLibrary.simpleMessage('Загрузка...'),
    'locationPermissionDenied': MessageLookupByLibrary.simpleMessage('Нет разрешений на доступ к геолокации'),
    'loginButton': MessageLookupByLibrary.simpleMessage('Войти'),
    'loginTitle': MessageLookupByLibrary.simpleMessage('Авторизация'),
    'myLocation': MessageLookupByLibrary.simpleMessage('Мое местоположение'),
    'notificationLanguage': MessageLookupByLibrary.simpleMessage('Язык оповещений'),
    'ok': MessageLookupByLibrary.simpleMessage('ОК'),
    'otpInstruction': m0,
    'otpTitle': MessageLookupByLibrary.simpleMessage('Подтверждение OTP'),
    'password': MessageLookupByLibrary.simpleMessage('Пароль'),
    'passwordsDoNotMatch': MessageLookupByLibrary.simpleMessage('Пароли не совпадают'),
    'phoneNumber': MessageLookupByLibrary.simpleMessage('Номер телефона'),
    'premiumExpired': MessageLookupByLibrary.simpleMessage('Премиум-режим истек'),
    'premiumExpiresIn': m1,
    'premiumModalContent': MessageLookupByLibrary.simpleMessage('Получите доступ к обновленным данным и дополнительным функциям, активировав премиум-режим.'),
    'premiumModalTitle': MessageLookupByLibrary.simpleMessage('Премиум-режим'),
    'registerButton': MessageLookupByLibrary.simpleMessage('Зарегистрироваться'),
    'registrationTitle': MessageLookupByLibrary.simpleMessage('Регистрация'),
    'resendCode': MessageLookupByLibrary.simpleMessage('Отправить код снова'),
    'settingsTitle': MessageLookupByLibrary.simpleMessage('Настройки'),
    'updateDatabase': MessageLookupByLibrary.simpleMessage('Обновить базу данных'),
    'verifyButton': MessageLookupByLibrary.simpleMessage('Подтвердить'),
    'watchAd': MessageLookupByLibrary.simpleMessage('Смотреть рекламу')
  };
}
