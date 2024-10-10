import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MyLocationButton extends StatelessWidget {
  final GoogleMapController? controller;

  MyLocationButton({required this.controller});

  void _goToMyLocation(BuildContext context) async {
    // Проверяем и запрашиваем разрешение
    PermissionStatus status = await Permission.locationWhenInUse.status;
    if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
      status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        // Разрешение предоставлено, получаем местоположение
        _animateToUserLocation();
      } else {
        // Разрешение не предоставлено, показываем сообщение
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Доступ к местоположению необходим для использования этой функции.')),
        );
      }
    } else if (status.isGranted) {
      // Разрешение уже предоставлено, получаем местоположение
      _animateToUserLocation();
    }
  }

  void _animateToUserLocation() async {
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
    return FloatingActionButton(
      child: Icon(Icons.my_location, color: Colors.white),
      onPressed: () => _goToMyLocation(context),
      tooltip: 'Мое местоположение',
    );
  }
}
