// lib/models/marker.dart
class CustomMarker {
  final String id;
  final double latitude;
  final double longitude;
  final int cameraType;

  CustomMarker({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.cameraType,
  });

  factory CustomMarker.fromJson(Map<String, dynamic> json) {
    return CustomMarker(
      id: json['id'].toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      cameraType: json['cameraType'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'cameraType': cameraType,
    };
  }

  @override
  String toString() {
    return 'Marker(id: $id, latitude: $latitude, longitude: $longitude, cameraType: $cameraType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomMarker &&
        other.id == id &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.cameraType == cameraType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    latitude.hashCode ^
    longitude.hashCode ^
    cameraType.hashCode;
  }
}
