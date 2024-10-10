import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oqyul/services/ad_service.dart';
import 'package:provider/provider.dart';
import '../blocs/premium/premium_bloc.dart';

class UpdateDatabaseButton extends StatelessWidget {
  // Future<void> _onPressed(BuildContext context, PremiumState state) async {
  //   if (state is PremiumActive) {
  //     try {
  //       // Получаем текущие координаты пользователя
  //       Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //       );
  //
  //       // Обновление маркеров через API
  //       BlocProvider.of<MapBloc>(context).add(MapLoadMarkers(
  //         latitude: position.latitude,
  //         longitude: position.longitude,
  //       ));
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('База данных успешно обновлена')),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Ошибка получения местоположения: $e')),
  //       );
  //     }
  //   } else if (state is PremiumAdsInProgress || state is PremiumInactive) {
  //     // Открыть модальное окно с предложением посмотреть рекламу
  //     showDialog(
  //       context: context,
  //       builder: (context) => PremiumModal(),
  //     );
  //   }
  //
  //   if (state is PremiumActive) {
  //
  //         try {
  //           Provider.of<AdService>(context).showRewardedAd(
  //                 (reward) {
  //               // Пользователь заработал награду, продлеваем премиум
  //               context.read<PremiumBloc>().add(PremiumExtend());
  //             },
  //                 () {
  //               // Реклама закрыта
  //             },
  //           );
  //         } catch (e) {
  //           // Реклама не готова
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text('Реклама не готова, попробуйте позже.')),
  //           );
  //           print('ошибка при показе рекламы: $e');
  //         }
  //   } else {
  //         // Ваш существующий код для обновления базы данных или просмотра рекламы
  //         try{
  //           Provider.of<AdService>(context).showRewardedAd((reward) {
  //             // Пользователь заработал награду, увеличиваем счетчик просмотренных реклам
  //             context.read<PremiumBloc>().add(PremiumWatchAd());
  //           }, () {
  //             // Реклама закрыта
  //           });
  //         } catch (e) {
  //           // Реклама не готова
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text('Реклама не готова, попробуйте позже.')),
  //           );
  //           print('ошибка при показе рекламы: $e');
  //         }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PremiumBloc, PremiumState>(
      builder: (context, state) {
        Color buttonColor;
        String buttonText;

        if (state is PremiumActive) {
          buttonColor = Colors.green;
          buttonText = 'Продлить подписку';
        } else if (state is PremiumAdsInProgress) {
          buttonColor = Colors.yellow;
          buttonText = 'Продолжить просмотр рекламы';
        } else {
          buttonColor = Colors.red;
          buttonText = 'Обновить базу данных';
        }

        return Container(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: buttonColor,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {
              if (state is PremiumActive) {

                try {
                  Provider.of<AdService>(context, listen: false).showRewardedAd(
                        (reward) {
                      // Пользователь заработал награду, продлеваем премиум
                      context.read<PremiumBloc>().add(PremiumExtend());
                    },
                        () {
                      // Реклама закрыта
                    },
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Реклама не готова, попробуйте позже.')),
                  );
                  print('ошибка при показе рекламы: $e');
                }
              } else {
                // Ваш существующий код для обновления базы данных или просмотра рекламы
                try{
                  Provider.of<AdService>(context, listen: false).showRewardedAd((reward) {
                    // Пользователь заработал награду, увеличиваем счетчик просмотренных реклам
                    context.read<PremiumBloc>().add(PremiumWatchAd());
                  }, () {
                    // Реклама закрыта
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Реклама не готова, попробуйте позже.')),
                  );
                  print('ошибка при показе рекламы: $e');
                }
              }
            },
            // onPressed: () => _onPressed(context, state),
            child: Text(buttonText),
          ),
        );
      },
    );
  }
}
