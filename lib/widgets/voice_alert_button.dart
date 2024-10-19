// lib/widgets/voice_alert_button.dart
import 'package:oqyul/viev_models/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VoiceAlertButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapViewModel = ref.watch(mapViewModelProvider.notifier);
    final isVoiceAlertEnabled = ref.watch(mapViewModelProvider).isVoiceAlertEnabled;

    return FloatingActionButton(
      onPressed: () {
        if (isVoiceAlertEnabled) {
          mapViewModel.disableVoiceAlert();
        } else {
          mapViewModel.enableVoiceAlert();
        }
      },
      backgroundColor: isVoiceAlertEnabled ? Colors.green : Colors.grey,
      child: Icon(isVoiceAlertEnabled ? Icons.volume_up : Icons.volume_off),
    );
  }
}

/*
class MapViewModel extends StateNotifier<MapViewModelState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _alertTimer;
  bool _isVoiceAlertEnabled = false;

  bool get isVoiceAlertEnabled => _isVoiceAlertEnabled;

  MapViewModel(this._read) : super(MapViewModelState.initial());

  // void enableVoiceAlert() {
  //   _isVoiceAlertEnabled = true;
  //   _alertTimer = Timer.periodic(
  //     Duration(seconds: AppConstants.markerAlertIntervalSeconds),
  //         (timer) => _playAlertSound(),
  //   );
  // }
  //
  // void disableVoiceAlert() {
  //   _isVoiceAlertEnabled = false;
  //   _alertTimer?.cancel();
  //   _audioPlayer.stop();
  // }
  //
  // Future<void> _playAlertSound() async {
  //   if (state.userLocation != null && _isVoiceAlertEnabled) {
  //     final nearestMarker = _findNearestMarker(state.userLocation!);
  //     if (nearestMarker != null) {
  //       final settings = _read(settingsViewModelProvider);
  //       String audioAsset;
  //
  //       switch (settings.voiceAlertLanguage) {
  //         case 'uz':
  //           audioAsset = 'assets/audio/alert_uzbek.mp3';
  //           break;
  //         case 'en':
  //           audioAsset = 'assets/audio/alert_english.mp3';
  //           break;
  //         case 'ru':
  //         default:
  //           audioAsset = 'assets/audio/alert_russian.mp3';
  //           break;
  //       }
  //
  //       await _audioPlayer.play(audioAsset, isLocal: true);
  //     }
  //   }
  // }

  // Marker? _findNearestMarker(LatLng userLocation) {
  //   // Пример поиска ближайшего маркера. Логику можно улучшить
  //   Marker? nearestMarker;
  //   double minDistance = double.infinity;
  //
  //   for (var marker in state.mapMarkers) {
  //     final distance = _calculateDistance(userLocation, LatLng(marker.latitude, marker.longitude));
  //     if (distance < minDistance) {
  //       minDistance = distance;
  //       nearestMarker = marker;
  //     }
  //   }
  //
  //   return nearestMarker;
  // }
  //
  // double _calculateDistance(LatLng start, LatLng end) {
  //   final lat1 = start.latitude;
  //   final lon1 = start.longitude;
  //   final lat2 = end.latitude;
  //   final lon2 = end.longitude;
  //
  //   const p = 0.017453292519943295;
  //   final a = 0.5 -
  //       cos((lat2 - lat1) * p) / 2 +
  //       cos(lat1 * p) * cos(lat2 * p) *
  //           (1 - cos((lon2 - lon1) * p)) / 2;
  //
  //   return 12742 * asin(sqrt(a)) * 1000; // Возвращает расстояние в метрах
  // }

  @override
  void dispose() {
    _alertTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
*/