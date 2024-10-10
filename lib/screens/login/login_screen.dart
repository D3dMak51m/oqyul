import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oqyul/blocs/authentication/auth_bloc.dart';
import 'package:oqyul/models/user.dart';
import 'package:oqyul/repositories/user_repository.dart';
import 'package:oqyul/services/auth_service.dart';
import 'package:oqyul/utils/validators.dart';
import 'package:oqyul/widgets/custom_button.dart';
import 'package:oqyul/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _phoneNumber = '';
  String _password = '';

  final AuthService _authService = AuthService();
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка авторизации: ${state.error}')),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  label: 'Номер телефона',
                  onSaved: (value) => _phoneNumber = value!,
                  validator: Validators.validatePhoneNumber,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'Пароль',
                  obscureText: true,
                  onSaved: (value) => _password = value!,
                  validator: Validators.validatePassword,
                ),
                SizedBox(height: 16),
                CustomButton(
                  text: 'Войти',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Выполняем авторизацию
                      try {
                        User user = await _authService.login(
                          phoneNumber: _phoneNumber,
                          password: _password,
                        );
                        // Сохраняем пользователя в репозитории
                        await _userRepository.persistToken(user);
                        BlocProvider.of<AuthBloc>(context).add(
                          AuthLoggedIn(user: user),
                        );
                      } catch (e) {
                        // Обработка ошибки авторизации
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ошибка авторизации: $e')),
                        );
                      }
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    // Переход к экрану восстановления пароля
                  },
                  child: Text('Забыли пароль?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
