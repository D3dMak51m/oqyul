import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/notification_service.dart';
import '../../models/marker.dart';

part 'voice_event.dart';
part 'voice_state.dart';

class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  final NotificationService notificationService;

  VoiceBloc({required this.notificationService}) : super(VoiceInitial()) {
    on<VoiceToggle>(_onToggleVoice);
    on<VoicePlayNotification>(_onPlayNotification);
  }

  void _onToggleVoice(VoiceToggle event, Emitter<VoiceState> emit) {
    emit(VoiceState(isVoiceOn: event.isVoiceOn));
  }

  void _onPlayNotification(VoicePlayNotification event, Emitter<VoiceState> emit) async {
    if (state.isVoiceOn) {
      await notificationService.playNotification(event.marker, event.distance);
    }
  }
}
