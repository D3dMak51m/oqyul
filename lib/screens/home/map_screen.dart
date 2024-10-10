import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oqyul/blocs/map/map_bloc.dart';
import 'package:oqyul/services/compass_service.dart';
import 'package:oqyul/services/location_service.dart';
import 'package:oqyul/widgets/map_controls/driving_mode_button.dart';
import 'package:oqyul/widgets/map_controls/my_location_button.dart';
import 'package:oqyul/widgets/map_controls/voice_toggle_button.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final LocationService _locationService = LocationService();
  final CompassService _compassService = CompassService();

  double _currentHeading = 0.0;
  StreamSubscription<double>? _compassSubscription;
  StreamSubscription<Position>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _locationService.startLocationUpdates();
    _initializeMap();
    _startCompass();
  }

  void _initializeMap() async {
    try {
      Position position = await _locationService.getCurrentPosition();
      BlocProvider.of<MapBloc>(context).add(MapLoadMarkers(
        latitude: position.latitude,
        longitude: position.longitude,
      ));

      // Обновляем местоположение пользователя
      BlocProvider.of<MapBloc>(context).add(MapUpdateLocation(
        location: LatLng(position.latitude, position.longitude),
      ));

      // Подписываемся на обновления местоположения
      _positionSubscription = _locationService.positionStream.listen((position) {
        BlocProvider.of<MapBloc>(context).add(MapUpdateLocation(
          location: LatLng(position.latitude, position.longitude),
        ));
        // Обновляем камеру, если режим вождения активен
        final state = BlocProvider.of<MapBloc>(context).state;
        if (state is MapLoaded && state.isDrivingMode) {
          _updateCamera(state);
        }
      });
    } catch (e) {
      print('Ошибка получения местоположения: $e');
      // Обработка ошибок
    }
  }

  void _startCompass() {
    _compassSubscription = _compassService.headingStream.listen((heading) {
      setState(() {
        _currentHeading = heading;
      });
      // Обновляем камеру, если режим вождения активен
      final state = BlocProvider.of<MapBloc>(context).state;
      if (state is MapLoaded && state.isDrivingMode) {
        _updateCamera(state);
      }
    });
  }

  void _updateCamera(MapLoaded state) {
    if (_controller != null) {
      final CameraPosition newCameraPosition = CameraPosition(
        target: state.userLocation ?? LatLng(0, 0),
        zoom: state.isDrivingMode ? 18.5 : 17,
        tilt: state.isDrivingMode ? 55 : 0,
        bearing: state.isDrivingMode ? _currentHeading : 0,
      );
      _controller!.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
    }
  }

  @override
  void dispose() {
    _locationService.stopLocationUpdates();
    _compassSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
      listener: (context, state) {
        if (state is MapLoaded && state.userLocation != null) {
          _updateCamera(state);
        }
      },
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MapLoaded) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: state.userLocation ?? LatLng(0, 0),
                    zoom: 17,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  markers: state.markers,
                  onMapCreated: (controller) {
                    _controller = controller;
                    _updateCamera(state);
                  },
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Column(
                    children: [
                      MyLocationButton(controller: _controller),
                      SizedBox(height: 10),
                      DrivingModeButton(),
                      SizedBox(height: 10),
                      VoiceToggleButton(),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Ошибка загрузки карты'));
          }
        },
      ),
    );
  }
}
