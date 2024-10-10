import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oqyul/blocs/authentication/auth_bloc.dart';
import 'package:oqyul/models/user.dart';
import 'package:oqyul/repositories/user_repository.dart';
import 'package:oqyul/services/auth_service.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String fullName;
  final String carNumber;
  final String password;

  OTPVerificationScreen({
    required this.phoneNumber,
    required this.fullName,
    required this.carNumber,
    required this.password,
  });

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  String _otpCode = '';
  final AuthService _authService = AuthService();
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _authService.sendOtpCode(widget.phoneNumber);
  }

  void _verifyCode() async {
    final isValid = await _authService.verifyOtpCode(widget.phoneNumber, _otpCode);
    if (isValid) {
      // Регистрация пользователя
      try {
        User user = await _authService.register(
          fullName: widget.fullName,
          carNumber: widget.carNumber,
          phoneNumber: widget.phoneNumber,
          password: widget.password,
        );
        // Сохраняем пользователя в репозитории
        await _userRepository.persistToken(user);
        // Завершаем регистрацию
        BlocProvider.of<AuthBloc>(context).add(AuthLoggedIn(user: user));
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Обработка ошибки регистрации
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка регистрации: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Неверный код. Попробуйте снова.')),
      );
    }
  }

  void _resendCode() {
    _authService.sendOtpCode(widget.phoneNumber);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Код отправлен повторно.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Подтверждение OTP'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Введите код, отправленный на номер ${widget.phoneNumber}'),
            SizedBox(height: 16),
            PinCodeTextField(
              length: 4,
              onChanged: (value) => _otpCode = value,
              appContext: context,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verifyCode,
              child: Text('Подтвердить'),
            ),
            TextButton(
              onPressed: _resendCode,
              child: Text('Отправить код снова'),
            ),
          ],
        ),
      ),
    );
  }
}
