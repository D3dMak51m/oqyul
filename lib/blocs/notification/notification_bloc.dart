import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oqyul/services/notification_service.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService notificationService;

  NotificationBloc({required this.notificationService}) : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) {
    });
  }
}
