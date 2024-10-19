// lib/providers/marker_provider.dart
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
    // Вызываем _loadMarkers при старте
    _loadMarkers();
    _startPeriodicUpdate();

    // Подписка на изменение премиум-режима
    _ref.listen(premiumProvider, (previous, next) {
      if (next.isPremiumValid) {
        refreshMarkersFromAPI();  // Загрузка с API при премиум-режиме
      } else {
        refreshMarkersFromLocal();  // Локальная загрузка маркеров
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
      state = markers;  // Обновляем состояние
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

        final response = await http.get(uri);
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final List<CustomMarker> markers = data.map((json) => CustomMarker.fromJson(json)).toList();
          state = markers;  // Обновляем состояние
          print('Маркер обновлен из API. Количество маркеров: ${markers.length}');
        } else {
          print('Ошибка загрузки маркеров из API: ${response.statusCode}');
        }
      } else {
        print('Не удалось получить местоположение пользователя.');
      }
    } catch (e) {
      print('Ошибка при подключении к API: $e');
    }
  }

  Future<void> refreshMarkersFromAPI() async {
    await _fetchMarkersFromAPI();
  }

  Future<void> refreshMarkersFromLocal() async {
    await _fetchMarkersFromLocal();
  }

  Future<void> refreshMarkers() async {
    await _loadMarkers();
  }
}

final markerProvider = StateNotifierProvider<MarkerNotifier, List<CustomMarker>>(
      (ref) => MarkerNotifier(ref),
);

final locationServiceProvider = Provider((ref) => LocationService());
