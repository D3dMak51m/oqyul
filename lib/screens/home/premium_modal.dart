import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oqyul/blocs/premium/premium_bloc.dart';


class PremiumModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PremiumBloc, PremiumState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text('Премиум-режим'),
          content: Text(
            'Получите доступ к обновленным данным и дополнительным функциям, активировав премиум-режим.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                // Запуск просмотра рекламы
                BlocProvider.of<PremiumBloc>(context).add(PremiumWatchAd());
                Navigator.pop(context);
              },
              child: Text('Смотреть рекламу'),
            ),
          ],
        );
      },
    );
  }
}
