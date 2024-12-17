import '../models/marker_model.dart';
import '../services/voice_notification_service.dart';
import '../controllers/map_controller.dart';
import '../utils/location_utils.dart';

class VoiceController {
  bool voiceNotificationsEnabled = true;
  final Set<int> _triggered500 = {};
  final Set<int> _triggered200 = {};

  final voiceService = VoiceNotificationService();
  MapController? _mapController;

  void setMapController(MapController controller) {
    _mapController = controller;
    _mapController!.locationService.onLocationChanged.listen((loc) {
      checkVoiceTriggers();
    });
  }

  void dispose() {
    voiceService.dispose();
  }

  void toggleVoiceNotifications() {
    voiceNotificationsEnabled = !voiceNotificationsEnabled;
  }

  void setLanguage(String lang) {
    voiceService.currentLanguage = lang;
  }

  Future<void> checkVoiceTriggers() async {
    if (!voiceNotificationsEnabled || _mapController?.currentUserLocation == null) return;

    final userLoc = _mapController!.currentUserLocation!;
    final visibleMarkers = _mapController!.visibleMarkers.value;
    final allMarkers = _mapController!.allMarkersData;

    for (final marker in visibleMarkers) {
      final mId = int.tryParse(marker.markerId.value.replaceAll('cluster_', '').split('_')[0]) ?? -1;
      if (mId == -1) continue;

      final originalMarker = allMarkers.firstWhere((e) => e.id == mId, orElse: () => MarkerModel(id: -1, latitude: 0, longitude: 0, cameraType: 0));
      if (originalMarker.id == -1) continue;

      final dist = distanceBetween(
          userLoc.latitude!,
          userLoc.longitude!,
          originalMarker.latitude,
          originalMarker.longitude
      );

      if (dist <= 200) {
        if (!_triggered200.contains(mId)) {
          _triggered200.add(mId);
          _triggered500.add(mId);
          await voiceService.playVoiceNotification(originalMarker.cameraType, 200);
        }
      } else if (dist <= 500) {
        if (!_triggered500.contains(mId)) {
          _triggered500.add(mId);
          await voiceService.playVoiceNotification(originalMarker.cameraType, 500);
        }
      } else {
        _triggered500.remove(mId);
        _triggered200.remove(mId);
      }
    }
  }
}
