import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/marker.dart';
import '../utils/constants.dart';

class ApiService {
  // Получение ближайших маркеров из API
  Future<List<Marker>> getNearbyMarkers({
    required double latitude,
    required double longitude,
    double maxDistance = 100000,
  }) async {
    final String url =
        '${Constants.apiUrl}/camera/nearby?latitude=$latitude&longitude=$longitude&maxDistance=$maxDistance';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Marker.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  // Получение маркеров из локального файла
  Future<List<Marker>> getLocalMarkers() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/markers.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => Marker.fromJson(json)).toList();
    } catch (e) {
      print('Ошибка при загрузке локальных маркеров: $e');
      throw e;
    }
  }


  Future<List<dynamic>> fetchMarkers(double latitude, double longitude, double radius) async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/markers.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData;
    } catch (e) {
      print('Ошибка при получении маркеров из API: $e');
      throw e;
    }
  }
}
