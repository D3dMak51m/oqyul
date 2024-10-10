part of 'voice_bloc.dart';

abstract class VoiceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VoiceToggle extends VoiceEvent {
  final bool isVoiceOn;

  VoiceToggle({required this.isVoiceOn});

  @override
  List<Object?> get props => [isVoiceOn];
}

class VoicePlayNotification extends VoiceEvent {
  final Marker marker;
  final double distance;

  VoicePlayNotification({required this.marker, required this.distance});

  @override
  List<Object?> get props => [marker, distance];
}
