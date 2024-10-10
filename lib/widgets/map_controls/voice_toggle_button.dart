import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oqyul/blocs/voice_notification/voice_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceBloc, VoiceState>(
      builder: (context, state) {
        bool isVoiceOn = state.isVoiceOn;

        return FloatingActionButton(
          child: Icon(
            isVoiceOn ? Icons.volume_up : Icons.volume_off,
            color: Colors.white,
          ),
          onPressed: () async {
            // Проверяем и запрашиваем разрешение
            PermissionStatus status = await Permission.locationWhenInUse.status;
            if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
              status = await Permission.locationWhenInUse.request();
              if (status.isGranted) {
                // Разрешение предоставлено, переключаем звук
                BlocProvider.of<VoiceBloc>(context).add(
                  VoiceToggle(isVoiceOn: !isVoiceOn),
                );
              } else {
                // Разрешение не предоставлено, показываем сообщение
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Доступ к местоположению необходим для использования этой функции.')),
                );
              }
            } else if (status.isGranted) {
              // Разрешение уже предоставлено, переключаем звук
              BlocProvider.of<VoiceBloc>(context).add(
                VoiceToggle(isVoiceOn: !isVoiceOn),
              );
            }
          },
          tooltip: isVoiceOn ? 'Выключить звук' : 'Включить звук',
        );
      },
    );
  }
}
