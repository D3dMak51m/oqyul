part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationReceivedState extends NotificationState {
  final String message;

  NotificationReceivedState({required this.message});

  @override
  List<Object?> get props => [message];
}