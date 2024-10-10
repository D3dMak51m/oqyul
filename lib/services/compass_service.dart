import 'dart:async';
import 'package:flutter_compass/flutter_compass.dart';

class CompassService {
  static final CompassService _instance = CompassService._internal();
  factory CompassService() => _instance;
  CompassService._internal();

  Stream<double>? _headingStream;

  Stream<double> get headingStream {
    _headingStream ??= FlutterCompass.events!.map((event) => event.heading ?? 0);
    return _headingStream!;
  }
}
