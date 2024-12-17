import 'package:flutter/material.dart';
import '../controllers/map_controller.dart';
import '../utils/location_utils.dart';

class NearestMarkerWidget extends StatelessWidget {
  final MapController mapController;

  const NearestMarkerWidget({Key? key, required this.mapController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userLoc = mapController.currentUserLocation;
    if (userLoc == null) {
      return const SizedBox();
    }

    final nearest = mapController.getNearestMarker();
    if (nearest == null) {
      return const SizedBox();
    }

    final dist = distanceBetween(
        userLoc.latitude ?? 0,
        userLoc.longitude ?? 0,
        nearest.latitude,
        nearest.longitude
    );

    String distStr = dist < 1000
        ? '${dist.toStringAsFixed(0)} м'
        : '${(dist / 1000).toStringAsFixed(1)} км';

    String imagePath = 'assets/icons/1.png';
    switch (nearest.cameraType) {
      case 0: imagePath = 'assets/icons/0.png'; break;
      case 1: imagePath = 'assets/icons/1.png'; break;
      case 2: imagePath = 'assets/icons/2.png'; break;
      default: imagePath = 'assets/icons/1.png'; break;
    }


    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xff435158).withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(image: AssetImage(imagePath), width: 30),
          // const SizedBox(width: 8),
          // Text('Тип: ${nearest.cameraType}', style: TextStyle(color: Colors.white)),
          const SizedBox(width: 16),
          Text('Расстояние: $distStr', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}