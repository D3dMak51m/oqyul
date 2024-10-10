part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final User user;

  AuthLoggedIn({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthLoggedOut extends AuthEvent {}

class AuthRegister extends AuthEvent {
  final String fullName;
  final String carNumber;
  final String phoneNumber;
  final String password;

  AuthRegister({
    required this.fullName,
    required this.carNumber,
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, carNumber, phoneNumber, password];
}
