// lib/widgets/premium_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oqyul/models/premium.dart';
import 'package:oqyul/services/ads_service.dart';
import 'package:oqyul/utils/constants.dart';
import 'package:oqyul/viev_models/premium_view_model.dart';

class PremiumButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumState = ref.watch(premiumViewModelProvider);
    final premiumViewModel = ref.watch(premiumViewModelProvider.notifier);
    final adsService = ref.read(adsServiceProvider);

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          premiumState.isPremiumValid ? Colors.blue : Colors.red,
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      onPressed: () async {
        bool adShown = await adsService.showInterstitialAd(
          onAdClosed: () {
            // Действия после закрытия рекламы, если необходимо
            premiumState.isPremiumValid
                ? premiumViewModel.extendPremium()
                : premiumViewModel.activatePremium();
          },
        );

        if (!adShown) {
          // Уведомляем пользователя, если реклама ещё загружается
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Реклама еще загружается, попробуйте позже.')),
          );
        }
      },
      child: premiumState.isPremiumValid
          ? _buildPremiumActiveContent(premiumState)
          : _buildPremiumInactiveContent(premiumState),
    );
  }

  /// Строит контент кнопки для активного премиум-режима
  Widget _buildPremiumActiveContent(PremiumStatus premiumState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Премиум активен',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(width: 10),
        CircularProgressIndicator(
          value: _getRemainingTimeProgress(premiumState),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          backgroundColor: Colors.redAccent,
        ),
      ],
    );
  }

  Widget _buildPremiumInactiveContent(PremiumStatus premiumState) {
    return Text(
      'Нажмите для активации премиума (${premiumState.remainingAdViews}/5)',
      style: TextStyle(color: Colors.white),
    );
  }

  double _getRemainingTimeProgress(PremiumStatus premiumState) {
    if (premiumState.expirationTime == null) return 0.0;
    final totalDuration = AppConstants.premiumActivationDuration.inSeconds;
    final remainingDuration = premiumState.expirationTime!.difference(DateTime.now()).inSeconds;
    return remainingDuration / totalDuration;
  }
}
