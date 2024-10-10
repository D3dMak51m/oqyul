import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oqyul/l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
    locale.countryCode?.isEmpty ?? false ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }


  // Общие
  String get appName => Intl.message('Oqyul', name: 'appName', desc: 'Название приложения');

  String get ok => Intl.message('ОК', name: 'ok', desc: 'Кнопка ОК');
  String get cancel => Intl.message('Отмена', name: 'cancel', desc: 'Кнопка Отмена');
  String get error => Intl.message('Ошибка', name: 'error', desc: 'Сообщение об ошибке');
  String get loading => Intl.message('Загрузка...', name: 'loading', desc: 'Индикатор загрузки');

  // Экран авторизации
  String get loginTitle =>
      Intl.message('Авторизация', name: 'loginTitle', desc: 'Заголовок экрана авторизации');
  String get loginButton =>
      Intl.message('Войти', name: 'loginButton', desc: 'Кнопка входа в приложение');
  String get forgotPassword =>
      Intl.message('Забыли пароль?', name: 'forgotPassword', desc: 'Ссылка восстановления пароля');
  String get phoneNumber =>
      Intl.message('Номер телефона', name: 'phoneNumber', desc: 'Поле ввода номера телефона');
  String get password =>
      Intl.message('Пароль', name: 'password', desc: 'Поле ввода пароля');

  // Экран регистрации
  String get registrationTitle =>
      Intl.message('Регистрация', name: 'registrationTitle', desc: 'Заголовок экрана регистрации');
  String get registerButton =>
      Intl.message('Зарегистрироваться', name: 'registerButton', desc: 'Кнопка регистрации');
  String get fullName =>
      Intl.message('ФИО', name: 'fullName', desc: 'Поле ввода полного имени');
  String get carNumber =>
      Intl.message('Номер автомобиля', name: 'carNumber', desc: 'Поле ввода номера автомобиля');
  String get confirmPassword =>
      Intl.message('Подтвердите пароль', name: 'confirmPassword', desc: 'Поле подтверждения пароля');

  // Экран подтверждения OTP
  String get otpTitle => Intl.message('Подтверждение OTP', name: 'otpTitle', desc: 'Заголовок экрана OTP');
  String otpInstruction(String phoneNumber) => Intl.message(
    'Введите код, отправленный на номер $phoneNumber',
    name: 'otpInstruction',
    args: [phoneNumber],
    desc: 'Инструкция по вводу OTP-кода',
  );
  String get verifyButton =>
      Intl.message('Подтвердить', name: 'verifyButton', desc: 'Кнопка подтверждения OTP');
  String get resendCode =>
      Intl.message('Отправить код снова', name: 'resendCode', desc: 'Ссылка повторной отправки кода');
  String get invalidOtp =>
      Intl.message('Неверный код. Попробуйте снова.', name: 'invalidOtp', desc: 'Сообщение о неверном OTP-коде');
  String get codeResent =>
      Intl.message('Код отправлен повторно.', name: 'codeResent', desc: 'Сообщение о повторной отправке кода');

  // Главный экран
  String get homeTitle =>
      Intl.message('Главная', name: 'homeTitle', desc: 'Заголовок главного экрана');
  String get updateDatabase =>
      Intl.message('Обновить базу данных', name: 'updateDatabase', desc: 'Кнопка обновления базы данных');
  String get databaseUpdated =>
      Intl.message('База данных успешно обновлена', name: 'databaseUpdated', desc: 'Сообщение об успешном обновлении');
  String get premiumExpired =>
      Intl.message('Премиум-режим истек', name: 'premiumExpired', desc: 'Сообщение об истечении премиум-режима');

  // Настройки
  String get settingsTitle =>
      Intl.message('Настройки', name: 'settingsTitle', desc: 'Заголовок экрана настроек');
  String get darkMode =>
      Intl.message('Темная тема', name: 'darkMode', desc: 'Переключатель темной темы');
  String get language =>
      Intl.message('Язык интерфейса', name: 'language', desc: 'Настройка языка интерфейса');
  String get notificationLanguage =>
      Intl.message('Язык оповещений', name: 'notificationLanguage', desc: 'Настройка языка оповещений');

  // Языки
  String get languageRussian => Intl.message('Русский', name: 'languageRussian', desc: 'Русский язык');
  String get languageEnglish => Intl.message('English', name: 'languageEnglish', desc: 'Английский язык');
  String get languageUzbek => Intl.message('O\'zbekcha', name: 'languageUzbek', desc: 'Узбекский язык');

  // Ошибки и уведомления
  String get locationPermissionDenied =>
      Intl.message('Нет разрешений на доступ к геолокации', name: 'locationPermissionDenied', desc: 'Сообщение об отсутствии разрешений геолокации');
  String get errorLoadingMap =>
      Intl.message('Ошибка загрузки карты', name: 'errorLoadingMap', desc: 'Сообщение об ошибке загрузки карты');
  String get errorLoadingUserData =>
      Intl.message('Ошибка загрузки данных пользователя', name: 'errorLoadingUserData', desc: 'Сообщение об ошибке загрузки данных пользователя');
  String get errorLoadingSettings =>
      Intl.message('Ошибка загрузки настроек', name: 'errorLoadingSettings', desc: 'Сообщение об ошибке загрузки настроек');

  // Кнопки и подсказки
  String get myLocation =>
      Intl.message('Мое местоположение', name: 'myLocation', desc: 'Подсказка кнопки моего местоположения');
  String get enableDrivingMode =>
      Intl.message('Включить режим вождения', name: 'enableDrivingMode', desc: 'Подсказка включения режима вождения');
  String get disableDrivingMode =>
      Intl.message('Выключить режим вождения', name: 'disableDrivingMode', desc: 'Подсказка отключения режима вождения');
  String get enableSound =>
      Intl.message('Включить звук', name: 'enableSound', desc: 'Подсказка включения звука');
  String get disableSound =>
      Intl.message('Выключить звук', name: 'disableSound', desc: 'Подсказка отключения звука');

  // Модальное окно премиум-режима
  String get premiumModalTitle =>
      Intl.message('Премиум-режим', name: 'premiumModalTitle', desc: 'Заголовок модального окна премиум-режима');
  String get premiumModalContent =>
      Intl.message('Получите доступ к обновленным данным и дополнительным функциям, активировав премиум-режим.', name: 'premiumModalContent', desc: 'Содержание модального окна премиум-режима');
  String get watchAd =>
      Intl.message('Смотреть рекламу', name: 'watchAd', desc: 'Кнопка просмотра рекламы');

  // Прогресс-бар премиум-режима
  String premiumExpiresIn(String time) => Intl.message(
    'Премиум истечет через $time',
    name: 'premiumExpiresIn',
    args: [time],
    desc: 'Сообщение о времени истечения премиум-режима',
  );

  // Валидация
  String get invalidPhoneNumber =>
      Intl.message('Некорректный номер телефона', name: 'invalidPhoneNumber', desc: 'Сообщение о некорректном номере телефона');
  String get invalidPassword =>
      Intl.message('Пароль должен быть не менее 6 символов', name: 'invalidPassword', desc: 'Сообщение о некорректном пароле');
  String get invalidFullName =>
      Intl.message('Введите полное имя', name: 'invalidFullName', desc: 'Сообщение о некорректном имени');
  String get invalidCarNumber =>
      Intl.message('Введите номер автомобиля', name: 'invalidCarNumber', desc: 'Сообщение о некорректном номере автомобиля');
  String get passwordsDoNotMatch =>
      Intl.message('Пароли не совпадают', name: 'passwordsDoNotMatch', desc: 'Сообщение о несовпадении паролей');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru', 'uz'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
