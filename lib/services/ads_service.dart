// lib/services/ads_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Класс для управления рекламой в приложении
class AdsService {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;

  /// Инициализация Google Mobile Ads SDK
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    loadInterstitialAd(); // Загрузите рекламу при инициализации
  }

  /// Загрузка межстраничной рекламы
  void loadInterstitialAd() {
    if (_interstitialAd == null) { // Проверяем, чтобы не загружать снова, если уже есть реклама
      InterstitialAd.load(
        adUnitId: 'ca-app-pub-3677409032346147/3968532801',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              loadInterstitialAd(); // Перезагрузка только при неудаче
            }
          },
        ),
      );
    }
  }

  /// Показ межстраничной рекламы
  void showInterstitialAd({required Function onAdClosed}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          loadInterstitialAd(); // Перезагрузка после показа рекламы
          onAdClosed(); // Вызываем колбэк после закрытия рекламы
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          print('InterstitialAd failed to show: $error');
          loadInterstitialAd(); // Перезагружаем при ошибке показа
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null; // Устанавливаем null, чтобы отследить, что реклама была показана
    } else {
      print('Требуется предварительная загрузка рекламы');
      loadInterstitialAd();
    }
  }

  /// Уничтожение загруженной рекламы
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}

/// Провайдер для AdsService
final adsServiceProvider = Provider((ref) => AdsService());
