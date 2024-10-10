import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oqyul/blocs/map/map_bloc.dart';
import 'package:oqyul/utils/permissions.dart';
import 'package:permission_handler/permission_handler.dart';

class DrivingModeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        bool isDrivingMode = false;
        if (state is MapLoaded) {
          isDrivingMode = state.isDrivingMode;
        }

        return FloatingActionButton(
          child: Icon(
            isDrivingMode ? Icons.drive_eta : Icons.map,
            color: Colors.white,
          ),
          onPressed: () async {
            // Проверяем и запрашиваем разрешение
            PermissionStatus status = await Permission.locationWhenInUse.status;
            if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
              status = await Permission.locationWhenInUse.request();
              if (status.isGranted) {
                // Разрешение предоставлено, переключаем режим
                BlocProvider.of<MapBloc>(context).add(
                  MapToggleDrivingMode(isDrivingMode: !isDrivingMode),
                );
              } else {
                Permissions.requestLocationPermission();
                // Разрешение не предоставлено, показываем сообщение
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Доступ к местоположению необходим для использования этой функции.')),
                );
              }
            } else if (status.isGranted) {
              // Разрешение уже предоставлено, переключаем режим
              BlocProvider.of<MapBloc>(context).add(
                MapToggleDrivingMode(isDrivingMode: !isDrivingMode),
              );
            }
          },
          tooltip: isDrivingMode ? 'Выключить режим вождения' : 'Включить режим вождения',
        );
      },
    );
  }
}
