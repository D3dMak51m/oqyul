// lib/models/marker.dart
class Marker {
  final int id;
  final double latitude;
  final double longitude;
  final int cameraType;
  final DateTime createdOn;
  final DateTime? updatedOn;
  final DateTime? deletedOn;
  final bool isActive;

  Marker({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.cameraType,
    required this.createdOn,
    this.updatedOn,
    this.deletedOn,
    required this.isActive,
  });

  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
      id: json['id'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      cameraType: json['cameraType'] as int,
      createdOn: DateTime.parse(json['createdOn'] as String),
      updatedOn: json['updatedOn'] != null ? DateTime.parse(json['updatedOn'] as String) : null,
      deletedOn: json['deletedOn'] != null ? DateTime.parse(json['deletedOn'] as String) : null,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'cameraType': cameraType,
      'createdOn': createdOn.toIso8601String(),
      'updatedOn': updatedOn?.toIso8601String(),
      'deletedOn': deletedOn?.toIso8601String(),
      'isActive': isActive,
    };
  }
}
