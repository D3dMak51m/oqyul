import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/map_controller.dart';
import '../controllers/voice_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/premium_controller.dart';
import '../services/premium_service.dart'; // Импортируем PremiumService, чтобы создать экземпляр

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

  @override
  void initState() {
    super.initState();
    // Ранее было: premiumController = PremiumController(premiumService: PremiumControllerDependencies.premiumService);
    // Заменяем на создание собственного экземпляра:
    final premiumService = PremiumService();
    premiumController = PremiumController(premiumService: premiumService);
    premiumController.init();

    mapController.init();
    voiceController.setMapController(mapController);
    widget.settingsController.addListener(_onSettingsChanged);
  }

  void _onSettingsChanged() {
    // Обновить язык/тему карты
    _updateMapStyle();
    voiceController.setLanguage(widget.settingsController.currentLanguage);
  }

  Future<void> _updateMapStyle() async {
    // Проверим, что карта инициализирована
    if (mapController.isMapReady) {
      String style = '';
      if (widget.settingsController.isDarkTheme) {
        style = await DefaultAssetBundle.of(context).loadString('assets/map_styles/dark.json');
      } else {
        style = await DefaultAssetBundle.of(context).loadString('assets/map_styles/light.json');
      }
      mapController.setMapStyle(style);
    }
  }

  @override
  void dispose() {
    widget.settingsController.removeListener(_onSettingsChanged);
    mapController.dispose();
    voiceController.dispose();
    premiumController.dispose();
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
                TextButton(
                  onPressed: _onPremiumButtonPressed,
                  child: Text(
                    premiumController.getButtonText(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                ValueListenableBuilder<Set<Marker>>(
                    valueListenable: mapController.visibleMarkers,
                    builder: (context, markers, child) {
                      return GoogleMap(
                        onMapCreated: (controller) {
                          mapController.onMapCreated(controller);
                          _updateMapStyle();
                        },
                        initialCameraPosition: CameraPosition(
                          target: mapController.initialPosition,
                          zoom: mapController.currentZoom,
                        ),
                        markers: markers,
                        onCameraIdle: mapController.onCameraIdle,
                      );
                    }
                ),
                Positioned(
                  top: 10,
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
                        },
                        backgroundColor: voiceController.voiceNotificationsEnabled ? Colors.green : Colors.red,
                        child: voiceController.voiceNotificationsEnabled
                            ? const Icon(Icons.volume_up)
                            : const Icon(Icons.volume_off),
                      ),
                    ],
                  ),
                ),
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
