class PremiumStatus {
  final bool isActive;
  final DateTime? expiryDate;
  final int adsWatched; // Количество просмотренных реклам

  PremiumStatus({
    required this.isActive,
    this.expiryDate,
    this.adsWatched = 0,
  });

  factory PremiumStatus.fromJson(Map<String, dynamic> json) {
    return PremiumStatus(
      isActive: json['isActive'] as bool,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      adsWatched: json['adsWatched'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isActive': isActive,
      'expiryDate': expiryDate?.toIso8601String(),
      'adsWatched': adsWatched,
    };
  }

  // Метод для проверки, истек ли премиум
  bool get isExpired {
    if (!isActive || expiryDate == null) return true;
    return DateTime.now().isAfter(expiryDate!);
  }
}
