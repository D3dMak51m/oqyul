import 'package:oqyul/models/premium_status.dart';

class User {
  final String id;
  final String fullName;
  final String carNumber;
  final String phoneNumber;
  final String password; // В реальном приложении пароль должен храниться безопасно
  final PremiumStatus premiumStatus;

  User({
    required this.id,
    required this.fullName,
    required this.carNumber,
    required this.phoneNumber,
    required this.password,
    required this.premiumStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      carNumber: json['carNumber'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String,
      premiumStatus: PremiumStatus.fromJson(json['premiumStatus'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'carNumber': carNumber,
      'phoneNumber': phoneNumber,
      'password': password,
      'premiumStatus': premiumStatus.toJson(),
    };
  }

  // Метод для обновления премиум-статуса
  User copyWithPremiumStatus(PremiumStatus newStatus) {
    return User(
      id: id,
      fullName: fullName,
      carNumber: carNumber,
      phoneNumber: phoneNumber,
      password: password,
      premiumStatus: newStatus,
    );
  }
}

/*
class User {
  final String id;
  final String fullName;
  final String carNumber;
  final String phoneNumber;
  final PremiumStatus premiumStatus;

  User({
    required this.id,
    required this.fullName,
    required this.carNumber,
    required this.phoneNumber,
    required this.premiumStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      carNumber: json['carNumber'] as String,
      phoneNumber: json['phoneNumber'] as String,
      premiumStatus: PremiumStatus.fromJson(json['premiumStatus'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'carNumber': carNumber,
      'phoneNumber': phoneNumber,
      'premiumStatus': premiumStatus.toJson(),
    };
  }

  // Метод для обновления премиум-статуса
  User copyWithPremiumStatus(PremiumStatus newStatus) {
    return User(
      id: id,
      fullName: fullName,
      carNumber: carNumber,
      phoneNumber: phoneNumber,
      premiumStatus: newStatus,
    );
  }
}
 */