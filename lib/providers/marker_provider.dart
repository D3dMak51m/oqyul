// marker_provider.dart

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import '../models/marker.dart';
import 'premium_provider.dart';
import '../services/location_service.dart';

class MarkerNotifier extends StateNotifier<List<CustomMarker>> {
  final Ref _ref;

  MarkerNotifier(this._ref) : super([]) {
    _loadMarkers();
    _startPeriodicUpdate();

    _ref.listen(premiumProvider, (previous, next) {
      if (next.isPremiumValid) {
        refreshMarkersFromAPI();
      } else {
        refreshMarkersFromLocal();
      }
    });
  }

  void _startPeriodicUpdate() {
    Future.delayed(Duration(minutes: 10), () async {
      await _loadMarkers();
      _startPeriodicUpdate();
    });
  }

  Future<void> _loadMarkers() async {
    final isPremium = _ref.read(premiumProvider).isPremiumValid;
    if (isPremium) {
      await _fetchMarkersFromAPI();
    } else {
      await _fetchMarkersFromLocal();
    }
  }

  Future<void> _fetchMarkersFromLocal() async {
    try {
      final String response = await rootBundle.loadString('assets/data/markers.json');
      final List<dynamic> data = json.decode(response);
      final List<CustomMarker> markers = data.map((json) => CustomMarker.fromJson(json)).toList();
      state = markers;
      print('Маркер обновлен из локального хранилища. Количество маркеров: ${markers.length}');
    } catch (e) {
      print('Ошибка загрузки локальных маркеров: $e');
    }
  }

  Future<void> _fetchMarkersFromAPI() async {
    try {
      final userLocation = await _ref.read(locationServiceProvider).getUserLocation();
      if (userLocation != null) {
        final uri = Uri.parse(
          'http://194.135.36.43:5000/api/camera/nearby?latitude=${userLocation.latitude}&longitude=${userLocation.longitude}&maxDistance=10000',
        );

        print('Отправка запроса к API: $uri');

        final response = await http.get(uri);
        if (response.statusCode == 200) {
          print('Успешный ответ от API: ${response.body}');

          final List<dynamic> data = json.decode(response.body);
          final List<CustomMarker> markers = data.map((json) => CustomMarker.fromJson(json)).toList();
          state = markers;
          print('Маркер обновлен из API. Количество маркеров: ${markers.length}');
        } else {
          print('Ошибка загрузки маркеров из API с кодом статуса: ${response.statusCode}');
        }
      } else {
        print('Не удалось получить местоположение пользователя.');
      }
    } catch (e) {
      print('Ошибка при подключении к API: $e');
    }
  }

  Future<void> refreshMarkersFromAPI() async {
    print('Запрос на обновление маркеров из API.');
    await _fetchMarkersFromAPI();
  }

  Future<void> refreshMarkersFromLocal() async {
    print('Запрос на обновление маркеров из локального хранилища.');
    await _fetchMarkersFromLocal();
  }
}

final markerProvider = StateNotifierProvider<MarkerNotifier, List<CustomMarker>>(
      (ref) => MarkerNotifier(ref),
);

final locationServiceProvider = Provider((ref) => LocationService());
