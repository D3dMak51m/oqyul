class MarkerModel {
  final int id;
  final double latitude;
  final double longitude;
  final int cameraType;

  MarkerModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.cameraType,
  });

  factory MarkerModel.fromJson(Map<String, dynamic> json) {
    return MarkerModel(
      id: json['id'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      cameraType: json['cameraType'],
    );
  }
}
