import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oqyul/models/user.dart';
import 'package:oqyul/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc({required this.userRepository}) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthLoggedOut>(_onAuthLoggedOut);
    on<AuthRegister>(_onAuthRegister);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final bool isSignedIn = await userRepository.isSignedIn();
    if (isSignedIn) {
      final user = await userRepository.getUser();
      emit(AuthAuthenticated(user: user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onAuthLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await userRepository.persistToken(event.user);
    emit(AuthAuthenticated(user: event.user));
  }

  void _onAuthLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await userRepository.deleteToken();
    emit(AuthUnauthenticated());
  }

  void _onAuthRegister(AuthRegister event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await userRepository.register(
        fullName: event.fullName,
        carNumber: event.carNumber,
        phoneNumber: event.phoneNumber,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (error) {
      emit(AuthFailure(error: error.toString()));
    }
  }
}
