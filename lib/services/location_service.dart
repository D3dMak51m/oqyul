// lib/services/location_service.dart

import 'package:location/location.dart';

/// Сервис для работы с местоположением пользователя
class LocationService {
  final Location _location = Location();

  /// Проверка и запрос разрешений на доступ к местоположению
  Future<bool> _requestPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Проверяем, включена ли служба местоположения
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return false; // Если служба местоположения не включена
      }
    }

    // Проверяем, предоставлено ли разрешение на доступ к местоположению
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false; // Если разрешение не предоставлено
      }
    }

    return true; // Все разрешения предоставлены, служба включена
  }

  /// Получение текущего местоположения пользователя
  Future<LocationData?> getUserLocation() async {
    bool permissionGranted = await _requestPermission();
    if (!permissionGranted) {
      print('Нет доступа к службе местоположения');
      return null;
    }

    try {
      final locationData = await _location.getLocation();
      return locationData;
    } catch (e) {
      print('Ошибка при получении местоположения: $e');
      return null;
    }
  }

  /// Подписка на изменения местоположения (используется в режиме Drive Mode)
  Stream<LocationData> getLocationStream() {
    return _location.onLocationChanged;
  }
}
