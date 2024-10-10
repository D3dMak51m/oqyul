// lib/repositories/marker_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/marker.dart';
import '../services/api_service.dart';

class MarkerRepository {
  final ApiService apiService = ApiService();

  Future<List<Marker>> fetchMarkers({
    required bool isPremium,
    required double latitude,
    required double longitude,
    double maxDistance = 100000,
  }) async {
    if (isPremium) {
      // Если премиум активен, получаем маркеры из API
      return await apiService.getNearbyMarkers(
        latitude: latitude,
        longitude: longitude,
        maxDistance: maxDistance,
      );
    } else {
      // Если премиум не активен, загружаем маркеры из локального файла
      return await apiService.getLocalMarkers();
    }
  }

  Future<List<Marker>> fetchMarkersFromApi(
      double latitude, double longitude, double radius) async {
    final List<dynamic> data = await apiService.fetchMarkers(latitude, longitude, radius);
    return data.map((json) => Marker.fromJson(json)).toList();
  }

  Future<List<Marker>> fetchLocalMarkers() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/markers.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => Marker.fromJson(json)).toList();
    } catch (e) {
      print('Ошибка загрузки локальных маркеров: $e');
      return [];
    }
  }
}
