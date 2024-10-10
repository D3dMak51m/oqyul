class Validators {
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите ваше ФИО';
    }
    return null;
  }

  static String? validateCarNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите номер автомобиля';
    }
    // Дополнительная проверка формата номера автомобиля может быть добавлена здесь
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите номер телефона';
    }
    final RegExp phoneExp = RegExp(r'^\+?[0-9]{9,15}$');
    if (!phoneExp.hasMatch(value)) {
      return 'Неверный формат номера телефона';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите пароль';
    }
    if (value.length < 6) {
      return 'Пароль должен содержать не менее 6 символов';
    }
    return null;
  }

  static String? validateOtpCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите код из SMS';
    }
    if (value.length != 4) {
      return 'Код должен содержать 4 цифры';
    }
    return null;
  }
}
