import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'my_location_button.dart';
import 'driving_mode_button.dart';
import 'voice_toggle_button.dart';

class MapControlButtons extends StatelessWidget {
  final GoogleMapController? controller;

  MapControlButtons({this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      top: 10,
      child: Column(
        children: [
          MyLocationButton(controller: controller),
          SizedBox(height: 10),
          DrivingModeButton(),
          SizedBox(height: 10),
          VoiceToggleButton(),
        ],
      ),
    );
  }
}
