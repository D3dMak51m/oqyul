// models/otp_arguments.dart
class OTPArguments {
  final String phoneNumber;
  final String fullName;
  final String carNumber;
  final String password;

  OTPArguments({
    required this.phoneNumber,
    required this.fullName,
    required this.carNumber,
    required this.password,
  });
}
