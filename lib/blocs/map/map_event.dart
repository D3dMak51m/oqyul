part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MapLoadMarkers extends MapEvent {
  final double latitude;
  final double longitude;

  MapLoadMarkers({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}

class MapUpdateLocation extends MapEvent {
  final gm.LatLng location;

  MapUpdateLocation({required this.location});

  @override
  List<Object?> get props => [location];
}

class MapToggleDrivingMode extends MapEvent {
  final bool isDrivingMode;

  MapToggleDrivingMode({required this.isDrivingMode});

  @override
  List<Object?> get props => [isDrivingMode];
}

class MapToggleVoiceNotifications extends MapEvent {
  final bool isVoiceOn;

  MapToggleVoiceNotifications({required this.isVoiceOn});

  @override
  List<Object?> get props => [isVoiceOn];
}
