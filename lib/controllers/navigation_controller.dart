import 'dart:math' as Math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/directions_service.dart';

class NavigationController extends ChangeNotifier {
  bool _isNavigating = false;
  bool get isNavigating => _isNavigating;

  LatLng? _destination;

  List<LatLng> _currentRoutePoints = [];
  Polyline? _currentRoutePolyline;
  Polyline? get currentPolyline => _currentRoutePolyline;

  Duration _eta = Duration.zero;
  Duration get eta => _eta;

  double _remainingDistance = 0.0; // метр
  double get remainingDistance => _remainingDistance;

  String _nextManeuver = '';
  String get nextManeuver => _nextManeuver;

  Future<void> buildRoute(LatLng start, LatLng destination) async {
    _isNavigating = true;
    _destination = destination;

    final directionsResult = await DirectionsService.getRouteDetails(start, destination);

    _currentRoutePoints = directionsResult.points;
    _currentRoutePolyline = Polyline(
      polylineId: const PolylineId('nav_route'),
      points: _currentRoutePoints,
      color: const Color(0xFF1976D2),
      width: 5,
    );

    _eta = Duration(seconds: directionsResult.durationSeconds);
    _remainingDistance = directionsResult.distanceMeters.toDouble();
    _updateNextManeuver();
    notifyListeners();
  }

  // Обновление локации
  Future<void> updateLocation(LatLng currentPos) async {
    if (!_isNavigating || _destination == null) return;
    final distToEnd = _distanceBetween(currentPos, _destination!);
    if (distToEnd < 30) {
      cancelRoute();
      return;
    }

    double distToRoute = _distanceToPolyline(currentPos, _currentRoutePoints);
    if (distToRoute > 50) {
      final directionsResult = await DirectionsService.getRouteDetails(currentPos, _destination!);
      _currentRoutePoints = directionsResult.points;
      _currentRoutePolyline = Polyline(
        polylineId: const PolylineId('nav_route'),
        points: _currentRoutePoints,
        color: const Color(0xFF1976D2),
        width: 5,
      );

      _eta = Duration(seconds: directionsResult.durationSeconds);
      _remainingDistance = directionsResult.distanceMeters.toDouble();
    } else {
      _remainingDistance = distToEnd;
    }

    _updateNextManeuver();

    notifyListeners();
  }

  void cancelRoute() {
    _isNavigating = false;
    _destination = null;
    _currentRoutePoints.clear();
    _currentRoutePolyline = null;
    _eta = Duration.zero;
    _remainingDistance = 0.0;
    _nextManeuver = '';
    notifyListeners();
  }

  void _updateNextManeuver() {
    if (_currentRoutePoints.length < 2) {
      _nextManeuver = 'Прямо до финиша';
      return;
    }
    _nextManeuver = 'Через 300м поворот направо';
  }

  double _distanceBetween(LatLng a, LatLng b) {
    const R = 6371000;
    final dLat = _deg2rad(b.latitude - a.latitude);
    final dLon = _deg2rad(b.longitude - a.longitude);
    final lat1 = _deg2rad(a.latitude);
    final lat2 = _deg2rad(b.latitude);

    final s = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(lat1) * Math.cos(lat2) *
            Math.sin(dLon / 2) * Math.sin(dLon / 2);
    final c = 2 * Math.atan2(Math.sqrt(s), Math.sqrt(1 - s));
    return R * c; // метр
  }

  double _deg2rad(double deg) => deg * Math.pi / 180.0;

  double _distanceToPolyline(LatLng pos, List<LatLng> routePoints) {
    if (routePoints.length < 2) {
      return _distanceBetween(pos, routePoints.isEmpty ? pos : routePoints.first);
    }

    double minDist = double.infinity;
    for (int i = 0; i < routePoints.length - 1; i++) {
      final segDist = _pointToSegmentDistance(pos, routePoints[i], routePoints[i+1]);
      if (segDist < minDist) {
        minDist = segDist;
      }
    }
    return minDist;
  }

  double _pointToSegmentDistance(LatLng p, LatLng a, LatLng b) {
    final px = p.latitude;
    final py = p.longitude;
    final ax = a.latitude;
    final ay = a.longitude;
    final bx = b.latitude;
    final by = b.longitude;

    final ABx = bx - ax;
    final ABy = by - ay;
    final APx = px - ax;
    final APy = py - ay;
    final ab2 = ABx*ABx + ABy*ABy;
    if (ab2 == 0) {
      return _distanceBetween(p, a);
    }
    final t = (APx*ABx + APy*ABy) / ab2;
    if (t < 0) {
      return _distanceBetween(p, a);
    } else if (t > 1) {
      return _distanceBetween(p, b);
    }
    final projx = ax + ABx * t;
    final projy = ay + ABy * t;
    return _distanceBetween(p, LatLng(projx, projy));
  }
}
