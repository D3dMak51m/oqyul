import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import '../models/marker.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playNotification(Marker marker, double distance) async {
    List<String> audioFiles = [];

    if (distance <= 500 && distance > 150) {
      audioFiles.add('assets/sounds/500.mp3');
    } else if (distance <= 150) {
      audioFiles.add('assets/sounds/150.mp3');
    }

    switch (marker.cameraType) {
      case 0:
        audioFiles.add('assets/sounds/camera.mp3');
        break;
      case 1:
        audioFiles.add('assets/sounds/post.mp3');
        break;
      default:
        audioFiles.add('assets/sounds/alert.mp3');
    }

    for (String file in audioFiles) {
      ByteData bytes = await rootBundle.load(file);
      Uint8List soundBytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      await _audioPlayer.play(BytesSource(soundBytes));
    }
  }
}
