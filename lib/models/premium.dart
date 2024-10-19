// lib/models/premium.dart
/// Модель данных для управления состоянием премиум-подписки
class PremiumStatus {
  final bool isActive;
  final DateTime? expirationTime;
  final int remainingAdViews;

  /// Конструктор класса PremiumStatus
  PremiumStatus({
    required this.isActive,
    this.expirationTime,
    required this.remainingAdViews,
  });

  /// Создание объекта PremiumStatus из JSON
  factory PremiumStatus.fromJson(Map<String, dynamic> json) {
    return PremiumStatus(
      isActive: json['isActive'] as bool,
      expirationTime: json['expirationTime'] != null
          ? DateTime.parse(json['expirationTime'])
          : null,
      remainingAdViews: json['remainingAdViews'] as int,
    );
  }

  /// Преобразование объекта PremiumStatus в JSON
  Map<String, dynamic> toJson() {
    return {
      'isActive': isActive,
      'expirationTime': expirationTime?.toIso8601String(),
      'remainingAdViews': remainingAdViews,
    };
  }

  /// Копирование объекта PremiumStatus с новыми значениями
  PremiumStatus copyWith({
    bool? isActive,
    DateTime? expirationTime,
    int? remainingAdViews,
  }) {
    return PremiumStatus(
      isActive: isActive ?? this.isActive,
      expirationTime: expirationTime ?? this.expirationTime,
      remainingAdViews: remainingAdViews ?? this.remainingAdViews,
    );
  }

  /// Проверяет, активен ли премиум-режим и не истекло ли время
  bool get isPremiumValid {
    if (!isActive) return false;
    if (expirationTime == null) return false;
    return DateTime.now().isBefore(expirationTime!);
  }

  @override
  String toString() {
    return 'PremiumStatus(isActive: $isActive, expirationTime: $expirationTime, remainingAdViews: $remainingAdViews)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PremiumStatus &&
        other.isActive == isActive &&
        other.expirationTime == expirationTime &&
        other.remainingAdViews == remainingAdViews;
  }

  @override
  int get hashCode {
    return isActive.hashCode ^
    expirationTime.hashCode ^
    remainingAdViews.hashCode;
  }
}
