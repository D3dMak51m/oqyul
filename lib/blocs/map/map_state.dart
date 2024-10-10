part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  final gm.LatLng? userLocation;
  final bool isDrivingMode;
  final bool isVoiceOn;

  MapState({
    this.userLocation,
    this.isDrivingMode = false,
    this.isVoiceOn = true,
  });

  @override
  List<Object?> get props => [userLocation, isDrivingMode, isVoiceOn];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final Set<gm.Marker> markers;

  MapLoaded({
    required this.markers,
    gm.LatLng? userLocation,
    bool isDrivingMode = false,
    bool isVoiceOn = true,
  }) : super(
    userLocation: userLocation,
    isDrivingMode: isDrivingMode,
    isVoiceOn: isVoiceOn,
  );

  @override
  List<Object?> get props => [markers, userLocation, isDrivingMode, isVoiceOn];

  MapLoaded copyWith({
    Set<gm.Marker>? markers,
    gm.LatLng? userLocation,
    bool? isDrivingMode,
    bool? isVoiceOn,
  }) {
    return MapLoaded(
      markers: markers ?? this.markers,
      userLocation: userLocation ?? this.userLocation,
      isDrivingMode: isDrivingMode ?? this.isDrivingMode,
      isVoiceOn: isVoiceOn ?? this.isVoiceOn,
    );
  }
}

class MapError extends MapState {
  final String error;

  MapError({required this.error});

  @override
  List<Object?> get props => [error];
}
