import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../blocs/premium/premium_bloc.dart';
import '../services/ad_service.dart';

class ExtendPremiumButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adService = Provider.of<AdService>(context);

    return BlocConsumer<PremiumBloc, PremiumState>(
      listener: (context, state) {
        // Обработка событий, если необходимо
      },
      builder: (context, state) {
        if (state is PremiumActive) {
          return ElevatedButton(
            onPressed: () {
              if (adService.rewardedAd != null) {
                adService.showRewardedAd(
                  (reward) {
                    // Пользователь заработал награду, продлеваем премиум
                    context.read<PremiumBloc>().add(PremiumExtend());
                  },
                  () {
                    // Реклама закрыта
                  },
                );
              } else {
                // Реклама не готова
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Реклама не готова, попробуйте позже.')),
                );
              }
            },
            child: Text('Продлить Премиум'),
          );
        } else {
          // Сохраняем прежний функционал для других состояний
          return ElevatedButton(
            onPressed: () {
              // Ваш существующий код для обновления базы данных или просмотра рекламы
              if (adService.rewardedAd != null) {
                adService.showRewardedAd((reward) {
                  // Пользователь заработал награду, увеличиваем счетчик просмотренных реклам
                  context.read<PremiumBloc>().add(PremiumWatchAd());
                }, () {
                  // Реклама закрыта
                });
              } else {
                // Реклама не готова
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Реклама не готова, попробуйте позже.')),
                );
              }
            },
            child: Text('Обновить Базу данных'),
          );
        }
      },
    );
  }
}
