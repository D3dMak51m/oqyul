import 'package:flutter/foundation.dart';
import '../services/premium_service.dart';

class PremiumController extends ValueNotifier<void> {
  final PremiumService premiumService;
  PremiumController({required this.premiumService}) : super(null);

  bool get isPremiumActive => premiumService.isPremiumActive;
  int get adsWatched => premiumService.adsWatched;
  DateTime? get premiumEndTime => premiumService.premiumEndTime;

  Future<void> init() async {
    await premiumService.init();
    notifyListeners();
  }

  String getButtonText() {
    if (!isPremiumActive) {
      return "Просмотр рекламы: $adsWatched/5";
    } else {
      if (premiumEndTime == null) return "Осталось: --:--";
      final remaining = premiumEndTime!.difference(DateTime.now());
      if (remaining.isNegative) {
        return "Премиум истёк";
      }

      final hours = remaining.inHours;
      final minutes = remaining.inMinutes % 60;
      return "Осталось: ${hours.toString().padLeft(2,'0')}:${minutes.toString().padLeft(2,'0')}";
    }
  }

  Future<void> watchAd() async {
    // Эмуляция просмотра рекламы:
    // Просто увеличим счетчик.
    await premiumService.incrementAdsWatched();

    if (!isPremiumActive && adsWatched >= 5) {
      // Активируем премиум
      await premiumService.activatePremium();
      await premiumService.resetAdsWatched();
    } else if (isPremiumActive) {
      // Продлеваем премиум на 3 часа
      await premiumService.extendPremium();
    }

    notifyListeners();
  }
}
