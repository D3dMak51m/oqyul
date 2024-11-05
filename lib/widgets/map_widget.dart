// lib/widgets/map_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oqyul/viev_models/map_view_model.dart';

class MapWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapViewModel = ref.watch(mapViewModelProvider.notifier);
    final mapState = ref.watch(mapViewModelProvider);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: mapState.userLocation ?? LatLng(0.0, 0.0),
        zoom: mapState.currentZoom,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      compassEnabled: true,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: true,
      mapToolbarEnabled: false,
      markers: mapState.mapMarkers,
      onCameraMove: mapViewModel.onCameraMove,
      onMapCreated: (controller) {
        mapViewModel.onMapCreated(controller);
      },
    );
  }
}



