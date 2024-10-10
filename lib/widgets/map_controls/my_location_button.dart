import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MyLocationButton extends StatelessWidget {
  final GoogleMapController? controller;

  MyLocationButton({required this.controller});

  void _goToMyLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      controller?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    } catch (e) {
      print('Ошибка получения местоположения: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.my_location, color: Colors.white),
      onPressed: _goToMyLocation,
      tooltip: 'Мое местоположение',
    );
  }
}
