// lib/widgets/nearest_marker_info_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oqyul/viev_models/map_view_model.dart';

class NearestMarkerInfoWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapViewModel = ref.read(mapViewModelProvider.notifier);
    final mapState = ref.watch(mapViewModelProvider);

    if (mapState.nearestMarker == null || mapState.distanceToNearestMarker == null) {
      return const SizedBox.shrink();
    }

    final marker = mapState.nearestMarker!;
    final distance = mapState.distanceToNearestMarker!;

    return GestureDetector(
      onTap: () {
        mapViewModel.centerMapOnMarker(marker);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getMarkerIcon(marker.cameraType),
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Тип: ${marker.cameraType}, Дистанция: ${distance.toStringAsFixed(0)}м',
              style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMarkerIcon(int cameraType) {
    switch (cameraType) {
      case 0:
        return Icons.radar;
      case 1:
        return Icons.camera_alt;
      case 2:
        return Icons.warning;
      default:
        return Icons.location_pin;
    }
  }
}
