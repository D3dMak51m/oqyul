part of 'voice_bloc.dart';

class VoiceState extends Equatable {
  final bool isVoiceOn;

  VoiceState({required this.isVoiceOn});

  @override
  List<Object?> get props => [isVoiceOn];
}

class VoiceInitial extends VoiceState {
  VoiceInitial() : super(isVoiceOn: true);
}
