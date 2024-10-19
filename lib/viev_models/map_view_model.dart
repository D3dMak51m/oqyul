// lib/view_models/map_view_model.dart
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oqyul/viev_models/settings_view_model.dart';
import 'dart:async';
import '../models/marker.dart';
import '../providers/marker_provider.dart';
import '../utils/constants.dart';
import '../services/location_service.dart';

class MapViewModel extends StateNotifier<MapViewModelState> {
  final LocationService _locationService;
  final Ref _ref;
  StreamSubscription<double?>? _compassSubscription;
  GoogleMapController? _mapController;
  bool _isVoiceAlertEnabled = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _alertTimer;

  MapViewModel(this._ref, this._locationService)
      : super(MapViewModelState.initial()) {
    // _updateMarkers();
    loadMapStyle();
    _subscribeToMarkerUpdates();  // Подписка на изменения маркеров
  }

  void _subscribeToMarkerUpdates() {
    // Подписываемся на изменения в markerProvider
    _ref.listen<List<CustomMarker>>(markerProvider, (previous, next) {
      _updateMarkers(next);  // Обновляем маркеры при изменении состояния
    });
  }

  /// Загрузка стиля карты на основе текущей темы
  Future<void> loadMapStyle() async {
    final isDarkMode = _ref.read(settingsViewModelProvider).isDarkTheme;
    String stylePath = isDarkMode ? 'assets/map/dark.json' : 'assets/map/light.json';

    try {
      final String styleJson = await rootBundle.loadString(stylePath);
      state = state.copyWith(mapStyle: styleJson);
    } catch (e) {
      print("Ошибка загрузки стиля карты: $e");
    }
  }

  void enableVoiceAlert() {
    _isVoiceAlertEnabled = true;
    _alertTimer = Timer.periodic(
      Duration(seconds: AppConstants.markerAlertIntervalSeconds),
          (timer) => playAlertSound(),
    );
  }

  void disableVoiceAlert() {
    _isVoiceAlertEnabled = false;
    _alertTimer?.cancel();
    _audioPlayer.stop();
  }

  Future<void> playAlertSound() async {
    if (state.userLocation != null && _isVoiceAlertEnabled) {
      final nearestMarker = findNearestMarker(state.userLocation!);
      if (nearestMarker != null) {
        final settings = _ref.read(settingsViewModelProvider);
        String audioAsset;

        switch (settings.voiceAlertLanguage) {
          case 'uz':
            audioAsset = 'assets/audio/alert_uzbek.mp3';
            break;
          case 'en':
            audioAsset = 'assets/audio/alert_english.mp3';
            break;
          case 'ru':
          default:
            audioAsset = 'assets/audio/alert_russian.mp3';
            break;
        }

        await _audioPlayer.play(AssetSource(audioAsset));
      }
    }
  }

  CustomMarker? findNearestMarker(LatLng userLocation) {
    CustomMarker? nearestMarker;
    double minDistance = double.infinity;

    for (var customMarker in _ref.read(markerProvider)) {
      final distance = calculateDistance(userLocation, LatLng(customMarker.latitude, customMarker.longitude));
      if (distance < minDistance) {
        minDistance = distance;
        nearestMarker = customMarker;
      }
    }

    return nearestMarker;
  }

  double calculateDistance(LatLng start, LatLng end) {
    final lat1 = start.latitude;
    final lon1 = start.longitude;
    final lat2 = end.latitude;
    final lon2 = end.longitude;

    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;

    return 12742 * asin(sqrt(a)) * 1000;
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // _updateMarkers();
    centerMapOnUserLocation();
  }

  void toggleMapMode() {
    if (state.isDriveMode) {
      _disableDriveMode();
    } else {
      _enableDriveMode();
    }
  }

  void _enableDriveMode() {
    _compassSubscription = _ref.read(compassProvider).listen((heading) {
      if (heading != null) {
        _mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: state.userLocation!,
            zoom: AppConstants.driveModeMapZoom,
            tilt: AppConstants.driveModeTilt,
            bearing: heading,
          ),
        ));
      }
    });
    state = state.copyWith(isDriveMode: true);
  }

  void _disableDriveMode() {
    _compassSubscription?.cancel();
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: state.userLocation!,
        zoom: AppConstants.defaultMapZoom,
        tilt: AppConstants.defaultTilt,
      ),
    ));

    state = state.copyWith(isDriveMode: false);
  }

  Future<void> centerMapOnUserLocation() async {
    final userLocation = await _locationService.getUserLocation();
    if (userLocation != null) {
      final position = LatLng(userLocation.latitude!, userLocation.longitude!);
      _mapController?.animateCamera(CameraUpdate.newLatLng(position));
      state = state.copyWith(userLocation: position);
    }
  }

  void _updateMarkers(List<CustomMarker> customMarkers) {
    Set<Marker> mapMarkers = customMarkers.map((customMarker) {
      return Marker(
        markerId: MarkerId(customMarker.id),
        position: LatLng(customMarker.latitude, customMarker.longitude),
        icon: _getMarkerIcon(customMarker.cameraType),
      );
    }).toSet();
    state = state.copyWith(mapMarkers: mapMarkers);  // Обновляем состояние карты
  }

  BitmapDescriptor _getMarkerIcon(int cameraType) {
    switch (cameraType) {
      case 0:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 1:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 2:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _mapController?.dispose();
    _alertTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}

class MapViewModelState {
  final String? mapStyle;
  final bool isVoiceAlertEnabled;
  final LatLng? userLocation;
  final Set<Marker> mapMarkers;
  final bool isDriveMode;

  MapViewModelState({
    required this.mapStyle,
    required this.isVoiceAlertEnabled,
    required this.userLocation,
    required this.mapMarkers,
    required this.isDriveMode,
  });

  factory MapViewModelState.initial() {
    return MapViewModelState(
      mapStyle: null,
      isVoiceAlertEnabled: false,
      userLocation: null,
      mapMarkers: {},
      isDriveMode: false,
    );
  }

  MapViewModelState copyWith({
    String? mapStyle,
    bool? isVoiceAlertEnabled,
    LatLng? userLocation,
    Set<Marker>? mapMarkers,
    bool? isDriveMode,
  }) {
    return MapViewModelState(
      mapStyle: mapStyle ?? this.mapStyle,
      isVoiceAlertEnabled: isVoiceAlertEnabled ?? this.isVoiceAlertEnabled,
      userLocation: userLocation ?? this.userLocation,
      mapMarkers: mapMarkers ?? this.mapMarkers,
      isDriveMode: isDriveMode ?? this.isDriveMode,
    );
  }
}

final mapViewModelProvider = StateNotifierProvider<MapViewModel, MapViewModelState>(
      (ref) => MapViewModel(ref, ref.read(locationServiceProvider)),
);

final compassProvider = Provider<Stream<double?>>((ref) {
  return FlutterCompass.events!.map((event) => event.heading);
});
