// controllers/map_controller.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../models/marker_model.dart';
import '../utils/cluster_utils.dart';
import '../utils/location_utils.dart';
import '../services/location_service.dart';
import '../services/compass_service.dart';

class MapController {
  GoogleMapController? _mapController;
  final ValueNotifier<Set<Marker>> visibleMarkers = ValueNotifier<Set<Marker>>({});
  final ValueNotifier<bool> isDriveMode = ValueNotifier<bool>(false);

  LocationData? currentUserLocation;
  LocationService locationService = LocationService();
  CompassService compassService = CompassService();

  List<MarkerModel> allMarkersData = [];
  LatLng initialPosition = const LatLng(41.31106548956276, 69.27971244305802);
  double currentZoom = 14.0;

  bool isCenteringOnUser = false;
  bool get driveMode => isDriveMode.value;

  StreamSubscription<LocationData>? _locationSub;
  StreamSubscription? _compassSub;

  bool _isMapReady = false;
  bool get isMapReady => _isMapReady;
  Function(LatLng)? onLocationUpdate;
  Marker? userCarMarker;
  BitmapDescriptor? carIcon;

  Future<void> init() async {
    await _loadMarkers();
    await loadCarIconOnce();
  }

  Future<void> loadCarIconOnce() async {
    carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48,48)),
      'assets/icons/car.png',
    );
  }

  Future<void> _loadMarkers() async {
    final jsonString = await rootBundle.loadString('assets/data/mmmarkers.json');
    final data = jsonDecode(jsonString) as List;
    allMarkersData = data.map((e) => MarkerModel.fromJson(e)).toList();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _isMapReady = true;
    _updateVisibleMarkers();
  }

  void dispose() {
    _compassSub?.cancel();
    _locationSub?.cancel();
  }

  Future<void> onCameraIdle() async {
    if (_mapController == null) return;
    final cameraPos = await _mapController!.getLatLng(const ScreenCoordinate(x: 0, y: 0));

    if (!driveMode && isCenteringOnUser && currentUserLocation != null) {
      final dist = distanceBetween(
        cameraPos.latitude,
        cameraPos.longitude,
        currentUserLocation!.latitude!,
        currentUserLocation!.longitude!,
      );
      if (dist > 10.0) {
        _disableCentering();
      }
    }

    final zoomLevel = await _mapController!.getZoomLevel();
    currentZoom = zoomLevel;

    _updateVisibleMarkers();
  }

  Future<void> _updateVisibleMarkers() async {
    if (_mapController == null) return;
    final bounds = await _mapController!.getVisibleRegion();
    final southWest = bounds.southwest;
    final northEast = bounds.northeast;

    final visibleData = allMarkersData.where((m) {
      return (m.latitude >= southWest.latitude && m.latitude <= northEast.latitude) &&
          (m.longitude >= southWest.longitude && m.longitude <= northEast.longitude);
    }).toList();

    List<MarkerWithScreenPos> markersWithPos = [];
    for (var m in visibleData) {
      final screenPoint = await _mapController!.getScreenCoordinate(
        LatLng(m.latitude, m.longitude),
      );
      markersWithPos.add(MarkerWithScreenPos(m, screenPoint));
    }

    double clusterRadius = (16 - currentZoom) * 10;
    final clustered = clusterMarkers(markersWithPos, clusterRadius);

    Set<Marker> newMarkers = {};
    for (var cluster in clustered) {
      if (cluster.length == 1) {
        final m = cluster.first.marker;
        final iconPath = 'assets/icons/${m.cameraType}.png';
        final bitmap = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          iconPath,
        );

        final marker = Marker(
            markerId: MarkerId(m.id.toString()),
            position: LatLng(m.latitude, m.longitude),
            icon: bitmap,
            infoWindow: InfoWindow(title: 'ID: ${m.id}', snippet: 'Type: ${m.cameraType}'));
        newMarkers.add(marker);
      } else {
        final clusterLatLng = calculateClusterCenter(cluster);
        final count = cluster.length;
        final clusterIcon = await createClusterBitmap(count);
        final marker = Marker(
            markerId: MarkerId('cluster_${cluster[0].marker.id}_${count}'),
            position: clusterLatLng,
            icon: clusterIcon,
            infoWindow: InfoWindow(title: 'Кластер', snippet: 'Кол-во: $count'));
        newMarkers.add(marker);
      }
    }

    visibleMarkers.value = newMarkers;
  }

  Future<void> centerOnUser() async {
    final loc = await locationService.requestLocation();
    if (loc == null) return;

    currentUserLocation = loc;
    final latLng = LatLng(loc.latitude!, loc.longitude!);
    await _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: 15),
    ));

    isCenteringOnUser = true;
    locationService.changeSettings(interval: 1000);
    _locationSub?.cancel();

    _locationSub = locationService.onLocationChanged.listen((loc) async {
      currentUserLocation = loc;
      if (isCenteringOnUser || driveMode) {
        final newPos = LatLng(loc.latitude!, loc.longitude!);
        _mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: newPos, zoom: driveMode ? 18 : 15),
        ));
      }
      await _updateUserMarker(loc);
      onLocationUpdate?.call(LatLng(loc.latitude!, loc.longitude!));
    });
  }

  Future<void> _updateUserMarker(LocationData loc) async {
    if (carIcon == null) {
      carIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48,48)),
        'assets/icons/car.png',
      );
    }
    final newPos = LatLng(loc.latitude!, loc.longitude!);

    userCarMarker = Marker(
      markerId: const MarkerId('user_car'),
      position: newPos,
      icon: carIcon!,
    );

    final currentSet = visibleMarkers.value;
    currentSet.removeWhere((m) => m.markerId.value == 'user_car');
    currentSet.add(userCarMarker!);
    visibleMarkers.value = Set<Marker>.from(currentSet);
  }

  void _disableCentering() {
    isCenteringOnUser = false;
  }

  Future<void> toggleDriveMode() async {
    if (driveMode) {
      _compassSub?.cancel();
      _compassSub = null;
      _disableCentering();
      isDriveMode.value = false;
    } else {
      await centerOnUser();
      currentZoom = 18;
      _compassSub = compassService.events?.listen((heading) {
        if (driveMode && currentUserLocation != null) {
          final pos = LatLng(currentUserLocation!.latitude!, currentUserLocation!.longitude!);
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: pos,
                zoom: 18,
                bearing: heading,
              ),
            ),
          );
        }
      });
      isDriveMode.value = true;
    }
  }

  MarkerModel? getNearestMarker() {
    if (currentUserLocation == null) return null;
    if (allMarkersData.isEmpty) return null;

    double userLat = currentUserLocation!.latitude!;
    double userLon = currentUserLocation!.longitude!;

    MarkerModel? nearest;
    double minDist = double.infinity;

    for (var marker in allMarkersData) {
      final dist = distanceBetween(userLat, userLon, marker.latitude, marker.longitude);
      if (dist < minDist) {
        minDist = dist;
        nearest = marker;
      }
    }
    return nearest;
  }

  Future<void> setMapStyle(String style) async {
    await _mapController?.setMapStyle(style);
  }
}
