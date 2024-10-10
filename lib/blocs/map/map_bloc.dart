// map_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:oqyul/models/marker.dart';
import '../../repositories/marker_repository.dart';
import '../../models/marker.dart' as model;
import '../premium/premium_bloc.dart';
import 'dart:async';

part 'map_state.dart';
part 'map_event.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MarkerRepository markerRepository;
  final PremiumBloc premiumBloc;
  StreamSubscription? premiumSubscription;
  Timer? _updateTimer; // Добавляем таймер

  MapBloc({required this.markerRepository, required this.premiumBloc}) : super(MapInitial()) {
    on<MapLoadMarkers>(_onLoadMarkers);
    on<MapUpdateLocation>(_onUpdateLocation);
    on<MapToggleDrivingMode>(_onToggleDrivingMode);
    on<MapToggleVoiceNotifications>(_onToggleVoiceNotifications);

    // Подписка на изменения премиум-статуса
    premiumSubscription = premiumBloc.stream.listen((premiumState) {
      if (premiumState is PremiumActive) {
        // Запускаем таймер, если он еще не запущен
        _startAutoUpdateTimer();
      } else {
        // Останавливаем таймер, если он запущен
        _stopAutoUpdateTimer();
      }

      // Загружаем маркеры при изменении премиум-статуса
      add(MapLoadMarkers(
        latitude: state.userLocation?.latitude ?? 0.0,
        longitude: state.userLocation?.longitude ?? 0.0,
      ));
    });
  }

  // Функция для запуска таймера
  void _startAutoUpdateTimer() {
    if (_updateTimer == null || !_updateTimer!.isActive) {
      _updateTimer = Timer.periodic(Duration(minutes: 10), (timer) {
        add(MapLoadMarkers(
          latitude: state.userLocation?.latitude ?? 0.0,
          longitude: state.userLocation?.longitude ?? 0.0,
        ));
      });
    }
  }

  // Функция для остановки таймера
  void _stopAutoUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  @override
  Future<void> close() {
    _updateTimer?.cancel(); // Останавливаем таймер при закрытии блока
    premiumSubscription?.cancel();
    return super.close();
  }

  void _onLoadMarkers(MapLoadMarkers event, Emitter<MapState> emit) async {
    emit(MapLoading());

    try {
      bool isPremium = premiumBloc.state is PremiumActive;

      double latitude = event.latitude;
      double longitude = event.longitude;

      final List<Marker> markers = await markerRepository.fetchMarkers(
        isPremium: isPremium,
        latitude: latitude,
        longitude: longitude,
      );

      // Преобразуем ваши маркеры в маркеры для Google Maps
      final Set<gm.Marker> mapMarkers = markers.map((Marker marker) {
        return gm.Marker(
          markerId: gm.MarkerId(marker.id.toString()),
          position: gm.LatLng(marker.latitude, marker.longitude),
          infoWindow: gm.InfoWindow(title: 'Камера: ${marker.cameraType}'),
        );
      }).toSet();

      emit(MapLoaded(
        markers: mapMarkers,
        userLocation: gm.LatLng(latitude, longitude),
        isDrivingMode: state.isDrivingMode,
        isVoiceOn: state.isVoiceOn,
      ));
    } catch (error) {
      emit(MapError(error: error.toString()));
    }
  }

  void _onUpdateLocation(MapUpdateLocation event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      emit((state as MapLoaded).copyWith(userLocation: event.location));
    }
  }

  void _onToggleDrivingMode(MapToggleDrivingMode event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      emit((state as MapLoaded).copyWith(isDrivingMode: event.isDrivingMode));
    }
  }

  void _onToggleVoiceNotifications(MapToggleVoiceNotifications event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      emit((state as MapLoaded).copyWith(isVoiceOn: event.isVoiceOn));
    }
  }
}
