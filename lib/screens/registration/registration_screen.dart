import 'package:flutter/material.dart';
import 'package:oqyul/models/otp_arguments.dart';
import 'package:oqyul/routes.dart';
import 'package:oqyul/utils/validators.dart';
import 'package:oqyul/widgets/custom_button.dart';
import 'package:oqyul/widgets/custom_text_field.dart';
// import '../utils/validators.dart';
// import '../widgets/custom_text_field.dart';
// import '../widgets/custom_button.dart';
import 'otp_verification_screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _carNumber = '';
  String _phoneNumber = '';
  String _password = '';

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Переходим к экрану OTP-подтверждения
      Navigator.pushNamed(
        context,
        Routes.otpVerification,
        arguments: OTPArguments(
          phoneNumber: _phoneNumber,
          fullName: _fullName,
          carNumber: _carNumber,
          password: _password,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                label: 'ФИО',
                onSaved: (value) => _fullName = value!,
                validator: Validators.validateFullName,
              ),
              SizedBox(height: 16),
              CustomTextField(
                label: 'Номер автомобиля',
                onSaved: (value) => _carNumber = value!,
                validator: Validators.validateCarNumber,
              ),
              SizedBox(height: 16),
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
                text: 'Зарегистрироваться',
                onPressed: _submitRegistration,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
