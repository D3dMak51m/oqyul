// lib/services/marker_service.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../models/marker.dart';

/// Сервис для загрузки маркеров
class MarkerService {
  /// Загрузка маркеров из локального файла JSON
  Future<List<CustomMarker>> loadMarkersFromLocal() async {
    try {
      final String response = await rootBundle.loadString('assets/data/markers.json');
      final List<dynamic> data = json.decode(response);
      final List<CustomMarker> markers = data.map((json) => CustomMarker.fromJson(json)).toList();
      return markers;
    } catch (e) {
      print('Ошибка загрузки маркеров из локального файла: $e');
      return [];
    }
  }

  /// Загрузка маркеров из удаленного API
  Future<List<CustomMarker>> loadMarkersFromApi(double latitude, double longitude, {int maxDistance = 10000}) async {
    try {
      final uri = Uri.parse(
        'http://194.135.36.43:5000/api/camera/nearby?latitude=$latitude&longitude=$longitude&maxDistance=$maxDistance',
      );

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<CustomMarker> markers = data.map((json) => CustomMarker.fromJson(json)).toList();
        return markers;
      } else {
        print('Ошибка загрузки маркеров из API: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Ошибка при подключении к API: $e');
      return [];
    }
  }
}
