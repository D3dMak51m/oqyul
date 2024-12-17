import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String _googleApiKey = 'AIzaSyARGIxyUatdnIImo0XDat9ZCjN_dA3Pbco';

class DirectionsResult {
  final List<LatLng> points;
  final int durationSeconds;
  final int distanceMeters;

  DirectionsResult({
    required this.points,
    required this.durationSeconds,
    required this.distanceMeters,
  });
}

class DirectionsService {
  static Future<DirectionsResult> getRouteDetails(LatLng start, LatLng end) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?"
            "origin=${start.latitude},${start.longitude}"
            "&destination=${end.latitude},${end.longitude}"
            "&key=$_googleApiKey"
            "&mode=driving"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && (data['routes'] as List).isNotEmpty) {
        final route = data['routes'][0];
        final overviewPolyline = route['overview_polyline']['points'];

        final legs = route['legs'] as List;
        int totalDuration = 0;
        int totalDistance = 0;
        if (legs.isNotEmpty) {
          for (var leg in legs) {
            final durationVal = (leg['duration']['value'] ?? 0) as num;
            final distanceVal = (leg['distance']['value'] ?? 0) as num;
            totalDuration += durationVal.toInt();
            totalDistance += distanceVal.toInt();
          }
        }

        final points = _decodePolyline(overviewPolyline);
        return DirectionsResult(
          points: points,
          durationSeconds: totalDuration,
          distanceMeters: totalDistance,
        );
      } else {
        print("Directions API error: ${data['status']}");
        return DirectionsResult(points: [], durationSeconds: 0, distanceMeters: 0);
      }
    } else {
      print("HTTP error: ${response.statusCode}");
      return DirectionsResult(points: [], durationSeconds: 0, distanceMeters: 0);
    }
  }

  static List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) == 1) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) == 1) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      points.add(LatLng(latitude, longitude));
    }
    return points;
  }
}
