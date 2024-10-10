part of 'notification_bloc.dart';


abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationReceived extends NotificationEvent {
  final String message;

  NotificationReceived({required this.message});

  @override
  List<Object?> get props => [message];
}