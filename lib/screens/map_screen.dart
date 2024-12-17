import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oqyol/controllers/navigation_controller.dart';
import 'package:oqyol/widgets/nearest_marker_widget.dart';
import '../controllers/map_controller.dart';
import '../controllers/voice_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/premium_controller.dart';
import '../services/premium_service.dart';
import 'language_selection_dialog.dart';

class MapScreen extends StatefulWidget {
  final SettingsController settingsController;
  const MapScreen({Key? key, required this.settingsController}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapController = MapController();
  final voiceController = VoiceController();
  late PremiumController premiumController;
  late NavigationController navigationController;

  @override
  void initState() {
    super.initState();
    final premiumService = PremiumService();
    premiumController = PremiumController(premiumService: premiumService);
    premiumController.init();

    mapController.init();
    voiceController.setMapController(mapController);
    widget.settingsController.addListener(_onSettingsChanged);

    navigationController = NavigationController();

    navigationController.addListener(() {
      setState(() {});
    });
    mapController.onLocationUpdate = (latLng) {
      navigationController.updateLocation(latLng);
    };
  }

  void _onSettingsChanged() {
    _updateMapStyle();
    print("Settings changed: isDarkTheme=${widget.settingsController.isDarkTheme}");
    voiceController.setLanguage(widget.settingsController.currentLanguage);
  }

  Future<void> _updateMapStyle() async {
    if (mapController.isMapReady) {
      String style;
      if (widget.settingsController.isDarkTheme) {
        style = await rootBundle.loadString('assets/map/dark.json');
      } else {
        style = await rootBundle.loadString('assets/map/light.json');
      }
      await mapController.setMapStyle(style);
    }
  }

  @override
  void dispose() {
    widget.settingsController.removeListener(_onSettingsChanged);
    mapController.dispose();
    voiceController.dispose();
    premiumController.dispose();
    navigationController.dispose();
    super.dispose();
  }

  Future<void> _onPremiumButtonPressed() async {
    if (!premiumController.isPremiumActive && premiumController.adsWatched < 5) {
      final result = await _showAdDialog("Посмотреть рекламу для активации премиум?");
      if (result == true) {
        await premiumController.watchAd();
      }
    } else {
      final result = await _showAdDialog("Посмотреть рекламу для продления премиум?");
      if (result == true) {
        await premiumController.watchAd();
      }
    }
  }

  Future<bool?> _showAdDialog(String message) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Реклама'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Просмотреть'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: premiumController,
        builder: (context, _, __) {
          return Scaffold(
            appBar: AppBar(
              leading: _buildSettingsMenu(),
              title: const Text('Marker Clustering & Map Modes Example'),
              actions: [
                ElevatedButton(
                  onPressed: _onPremiumButtonPressed,
                  child: Text(
                    premiumController.getButtonText(),
                    // style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                ValueListenableBuilder<Set<Marker>>(
                    valueListenable: mapController.visibleMarkers,
                    builder: (context, markers, child) {
                      Set<Polyline> polylines = {};
                      if (navigationController.currentPolyline != null) {
                        polylines = { navigationController.currentPolyline! };
                      }
                      return GoogleMap(
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        minMaxZoomPreference: const MinMaxZoomPreference(12, 30),
                        onMapCreated: (controller) {
                          mapController.onMapCreated(controller);
                          _updateMapStyle();
                        },
                        initialCameraPosition: CameraPosition(
                          target: mapController.initialPosition,
                          zoom: mapController.currentZoom,
                        ),
                        markers: markers,
                        polylines: polylines,
                        onCameraIdle: mapController.onCameraIdle,
                        onTap: _onMapTap,
                        myLocationEnabled: false,
                      );
                    }
                ),

                // Кнопки справа
                Positioned(
                  bottom: 100,
                  // top: 10,
                  right: 10,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: "center_user",
                        onPressed: () async {
                          await mapController.centerOnUser();
                        },
                        child: const Icon(Icons.my_location),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        heroTag: "toggle_drive",
                        onPressed: () async {
                          await mapController.toggleDriveMode();
                        },
                        child: ValueListenableBuilder<bool>(
                          valueListenable: mapController.isDriveMode,
                          builder: (context, drive, child) {
                            return Icon(drive ? Icons.navigation : Icons.map);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        heroTag: "toggle_voice",
                        onPressed: () {
                          voiceController.toggleVoiceNotifications();
                          setState(() {});  // <-- Trigger rebuild immediately
                        },
                        backgroundColor: voiceController.voiceNotificationsEnabled ? Colors.green : Colors.red,
                        child: voiceController.voiceNotificationsEnabled
                            ? const Icon(Icons.volume_up)
                            : const Icon(Icons.volume_off),
                      ),

                    ],
                  ),
                ),

                // Навигационный виджет
                if (navigationController.isNavigating)
                  Positioned(
                    top: 10,
                    left: 20,
                    right: 20,
                    child: _buildNavigationInfo(),
                  ),

                // Нижний виджет
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: NearestMarkerWidget(mapController: mapController),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }


  Widget _buildNavigationInfo() {
    final eta = navigationController.eta;
    final dist = navigationController.remainingDistance;

    String etaStr = '${eta.inMinutes} мин';
    if (eta.inHours > 0) {
      final h = eta.inHours;
      final m = eta.inMinutes % 60;
      etaStr = '$h ч $m мин';
    }
    String distStr = dist < 1000
        ? '${dist.toStringAsFixed(0)} м'
        : '${(dist / 1000).toStringAsFixed(1)} км';

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xff435158).withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Следующий маневр: ${navigationController.nextManeuver}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'До цели: $distStr, ETA: $etaStr',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          IconButton(
            highlightColor: Colors.red,
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              navigationController.cancelRoute();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  void _onMapTap(LatLng pos) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 120,
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text('Проложить маршрут сюда?', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final userLocation = mapController.currentUserLocation;
                    if (userLocation == null) return;

                    final start = LatLng(userLocation.latitude!, userLocation.longitude!);
                    await navigationController.buildRoute(start, pos);

                    await mapController.toggleDriveMode();
                  },
                  child: const Text('Проложить маршрут'),
                )
              ],
            ),
          );
        }
    );
  }

  Widget _buildSettingsMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.settings),
      onSelected: (value) async {
        if (value == 'theme') {
          await widget.settingsController.toggleTheme();
        } else if (value == 'language') {
          await _showLanguageDialog();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'theme',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Тёмная тема'),
              Switch(
                value: widget.settingsController.isDarkTheme,
                onChanged: (val) async {
                  Navigator.pop(context);
                  await widget.settingsController.toggleTheme();
                },
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'language',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Язык'),
              Text(widget.settingsController.currentLanguage),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showLanguageDialog() async {
    final selectedLang = await showDialog<String>(
      context: context,
      builder: (context) => const LanguageSelectionDialog(
        supportedLanguages: ['rus', 'eng'],
      ),
    );
    if (selectedLang != null && selectedLang.isNotEmpty) {
      await widget.settingsController.changeLanguage(selectedLang);
    }
  }
}