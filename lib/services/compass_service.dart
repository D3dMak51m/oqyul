import 'package:flutter_compass/flutter_compass.dart';

class CompassService {
  Stream<double>? get events => FlutterCompass.events?.map((event) => event.heading ?? 0.0);
}
