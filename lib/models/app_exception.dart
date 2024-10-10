class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException(this.message, [this.prefix]);

  @override
  String toString() {
    return '${prefix ?? 'Ошибка'}: $message';
  }
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message, 'Сетевая ошибка');
}

class ServerException extends AppException {
  ServerException(String message) : super(message, 'Ошибка сервера');
}

class CacheException extends AppException {
  CacheException(String message) : super(message, 'Ошибка кэша');
}
