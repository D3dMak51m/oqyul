// lib/widgets/map_mode_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oqyul/viev_models/map_view_model.dart';

class MapModeButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapViewModel = ref.watch(mapViewModelProvider.notifier);
    final isDriveMode = ref.watch(mapViewModelProvider).isDriveMode;

    return FloatingActionButton.extended(
      onPressed: () => mapViewModel.toggleMapMode(),
      label: Text(isDriveMode ? 'Drive Mode' : 'Default Mode'),
      icon: Icon(isDriveMode ? Icons.drive_eta : Icons.map),
      backgroundColor: isDriveMode ? Colors.blue : Colors.grey,
    );
  }
}
