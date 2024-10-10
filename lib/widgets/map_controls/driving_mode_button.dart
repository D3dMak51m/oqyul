import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oqyul/blocs/map/map_bloc.dart';

class DrivingModeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        bool isDrivingMode = false;
        if (state is MapLoaded) {
          isDrivingMode = state.isDrivingMode;
        }

        return IconButton(
          icon: Icon(
            isDrivingMode ? Icons.drive_eta : Icons.map,
            color: Colors.white,
          ),
          onPressed: () {
            BlocProvider.of<MapBloc>(context).add(
              MapToggleDrivingMode(isDrivingMode: !isDrivingMode),
            );
          },
          tooltip: isDrivingMode ? 'Выключить режим вождения' : 'Включить режим вождения',
        );
      },
    );
  }
}
