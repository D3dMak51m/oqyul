import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oqyul/blocs/voice_notification/voice_bloc.dart';

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
          onPressed: () {
            BlocProvider.of<VoiceBloc>(context).add(
              VoiceToggle(isVoiceOn: !isVoiceOn),
            );
          },
          tooltip: isVoiceOn ? 'Выключить звук' : 'Включить звук',
        );
      },
    );
  }
}
