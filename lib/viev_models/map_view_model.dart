// lib/view_models/map_view_model.dart
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:oqyul/viev_models/settings_view_model.dart';
import 'dart:async';
import '../models/marker.dart';
import '../providers/marker_provider.dart';
import '../utils/constants.dart';
import '../services/location_service.dart';
import 'dart:ui' as ui;


class MapViewModel extends StateNotifier<MapViewModelState> {
  final LocationService _locationService;
  final Ref _ref;
  StreamSubscription<double?>? _compassSubscription;
  StreamSubscription<LocationData>? _locationSubscription;
  GoogleMapController? _mapController;
  bool _isVoiceAlertEnabled = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _alertTimer;

  MapViewModel(this._ref, this._locationService) : super(MapViewModelState.initial()) {
    loadMapStyle();
    _subscribeToMarkerUpdates();
    _subscribeToThemeChanges();
  }

  void _subscribeToThemeChanges() {
    _ref.listen<bool>(settingsViewModelProvider.select((settings) => settings.isDarkTheme),
            (previous, isDarkMode) {
          loadMapStyle();
        });
  }

  // Подписываемся на изменения маркеров и обновляем видимые элементы
  void _subscribeToMarkerUpdates() {
    _ref.listen<List<CustomMarker>>(markerProvider, (previous, next) {
      _updateVisibleMarkers(next);
    });
  }

  // Метод для обновления видимых элементов на основе уровня зума
  void _updateVisibleMarkers(List<CustomMarker> markers) async {
    final currentZoom = state.currentZoom;
    final isZoomedIn = currentZoom >= 13;

    if (isZoomedIn) {
      state = state.copyWith(mapMarkers: _createMarkers(markers));
    } else {
      final pointSize = currentZoom >= 10 ? 8.0 : 4.0;
      state = state.copyWith(mapMarkers: await _createPoints(markers, pointSize));
    }
  }

  // Создаем маркеры для отображения при увеличенном масштабе
  Set<Marker> _createMarkers(List<CustomMarker> markers) {
    return markers.map((marker) {
      return Marker(
        markerId: MarkerId(marker.id),
        position: LatLng(marker.latitude, marker.longitude),
        icon: _getMarkerIcon(marker.cameraType),
      );
    }).toSet();
  }

  // Создаем точки для отображения при уменьшенном масштабе
  Future<Set<Marker>> _createPoints(List<CustomMarker> markers, double size) async {
    final BitmapDescriptor pointIcon = await _createCustomPointIcon(size);

    return markers.map((marker) {
      return Marker(
        markerId: MarkerId(marker.id),
        position: LatLng(marker.latitude, marker.longitude),
        icon: pointIcon,
        onTap: () {}, // Отключаем интерактивность
      );
    }).toSet();
  }

  Future<BitmapDescriptor> _createCustomPointIcon(double size) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = const ui.Color(0xFFFF0000); // цвет точки

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint);
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }
  // Обновление уровня зума
  void onCameraMove(CameraPosition position) {
    if (position.zoom != state.currentZoom) {
      state = state.copyWith(currentZoom: position.zoom);
      _updateVisibleMarkers(_ref.read(markerProvider));
    }
  }

  /// Загрузка стиля карты на основе текущей темы
  Future<void> loadMapStyle() async {
    final isDarkMode = _ref.read(settingsViewModelProvider).isDarkTheme;
    String stylePath = isDarkMode ? 'assets/map/dark.json' : 'assets/map/light.json';

    try {
      final String styleJson = await rootBundle.loadString(stylePath);
      state = state.copyWith(mapStyle: styleJson);

      // Устанавливаем стиль карты
      if (_mapController != null) {
        _mapController!.setMapStyle(styleJson);
      }
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
      final distance =
          calculateDistance(userLocation, LatLng(customMarker.latitude, customMarker.longitude));
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

  // Обновленный метод для поиска ближайшего маркера и обновления состояния
  void updateNearestMarker() {
    if (state.userLocation == null) return;

    final nearestMarker = findNearestMarker(state.userLocation!);
    if (nearestMarker != null) {
      final distance = calculateDistance(
          state.userLocation!, LatLng(nearestMarker.latitude, nearestMarker.longitude));
      state = state.copyWith(nearestMarker: nearestMarker, distanceToNearestMarker: distance);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    centerMapOnUserLocation();
    if (state.mapStyle != null) {
      _mapController!.setMapStyle(state.mapStyle);
    }
  }

  void toggleMapMode() {
    if (state.isDriveMode) {
      _disableDriveMode();
    } else {
      _enableDriveMode();
    }
  }

// Постоянное обновление местоположения пользователя в режиме Drive Mode
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

    // Подписка на обновления местоположения
    _locationSubscription = _locationService.getLocationStream().listen((newLocation) {
      final LatLng position = LatLng(newLocation.latitude!, newLocation.longitude!);
      state = state.copyWith(userLocation: position);
      updateNearestMarker();
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: AppConstants.driveModeMapZoom,
          tilt: AppConstants.driveModeTilt,
        ),
      ));
      state = state.copyWith(userLocation: position);
    });

    state = state.copyWith(isDriveMode: true);
  }

  // Центрировать картцу маркере
  void centerMapOnMarker(CustomMarker marker) {
    final position = LatLng(marker.latitude, marker.longitude);
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: position,
        zoom: AppConstants.driveModeMapZoom,
        tilt: AppConstants.driveModeTilt,
      ),
    ));
  }

// Отключение режима Drive Mode
  void _disableDriveMode() {
    _compassSubscription?.cancel();
    _locationSubscription?.cancel(); // Отменяем подписку на обновления местоположения
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
    _locationSubscription?.cancel();
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
  final CustomMarker? nearestMarker;
  final double? distanceToNearestMarker;
  final double currentZoom;

  MapViewModelState({
    required this.mapStyle,
    required this.isVoiceAlertEnabled,
    required this.userLocation,
    required this.mapMarkers,
    required this.isDriveMode,
    required this.nearestMarker,
    required this.distanceToNearestMarker,
    required this.currentZoom,
  });

  factory MapViewModelState.initial() {
    return MapViewModelState(
      mapStyle: null,
      isVoiceAlertEnabled: false,
      userLocation: null,
      mapMarkers: {},
      isDriveMode: false,
      nearestMarker: null,
      distanceToNearestMarker: null,
      currentZoom: AppConstants.defaultMapZoom,
    );
  }

  MapViewModelState copyWith({
    String? mapStyle,
    bool? isVoiceAlertEnabled,
    LatLng? userLocation,
    Set<Marker>? mapMarkers,
    bool? isDriveMode,
    CustomMarker? nearestMarker,
    double? distanceToNearestMarker,
    double? currentZoom,
  }) {
    return MapViewModelState(
      mapStyle: mapStyle ?? this.mapStyle,
      isVoiceAlertEnabled: isVoiceAlertEnabled ?? this.isVoiceAlertEnabled,
      userLocation: userLocation ?? this.userLocation,
      mapMarkers: mapMarkers ?? this.mapMarkers,
      isDriveMode: isDriveMode ?? this.isDriveMode,
      nearestMarker: nearestMarker ?? this.nearestMarker,
      distanceToNearestMarker: distanceToNearestMarker ?? this.distanceToNearestMarker,
      currentZoom: currentZoom ?? this.currentZoom,
    );
  }
}

final mapViewModelProvider = StateNotifierProvider<MapViewModel, MapViewModelState>(
  (ref) => MapViewModel(ref, ref.read(locationServiceProvider)),
);

final compassProvider = Provider<Stream<double?>>((ref) {
  return FlutterCompass.events!.map((event) => event.heading);
});
