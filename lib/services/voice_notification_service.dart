import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';

class VoiceNotificationService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String currentLanguage = 'rus';

  VoiceNotificationService();

  void dispose() {
    _audioPlayer.dispose();
  }

  Future<void> playVoiceNotification(int cameraType, int distance) async {
    await _audioPlayer.stop();

    String typeStr = cameraType.toString();
    final file1 = await _getSoundFile(currentLanguage, typeStr, '1');
    final fileDist = await _getSoundFile(currentLanguage, typeStr, distance.toString());

    await _playSequenceOfSounds([file1, fileDist]);
  }

  Future<String> _getSoundFile(String lang, String type, String fileName) async {
    String path = 'assets/sounds/$type/$fileName.mp3';
    if (!await _assetExists(path)) {
      String defaultPath = 'assets/sounds/$fileName.mp3';
      if (await _assetExists(defaultPath)) {
        return defaultPath;
      } else {
        print("Sound file not found: $path and no default");
        return '';
      }
    }
    return path;
  }

  Future<bool> _assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _playSequenceOfSounds(List<String> files) async {
    for (var file in files) {
      if (file.isEmpty) continue;
      await _audioPlayer.play(AssetSource(file.replaceFirst('assets/', '')), volume: 1.0);
      await _waitForComplete();
    }
  }

  Future<void> _waitForComplete() async {
    Completer<void> completer = Completer();
    StreamSubscription? sub;
    sub = _audioPlayer.onPlayerComplete.listen((event) {
      sub?.cancel();
      completer.complete();
    });
    await completer.future;
  }
}
