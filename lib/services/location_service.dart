import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Stream<LocationData> get onLocationChanged => _location.onLocationChanged;

  Future<LocationData?> requestLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await _location.getLocation();
  }

  void changeSettings({int interval = 1000}) {
    _location.changeSettings(interval: interval);
  }
}
