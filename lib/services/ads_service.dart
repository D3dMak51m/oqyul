import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd;
  bool _isAdLoading = false;
  int _numInterstitialLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;

  AdsService() {
    _initializeAds();
  }

  Future<void> _initializeAds() async {
    await MobileAds.instance.initialize();
    _loadInterstitialAd();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3677409032346147/2655089746', // Ваш Ad Unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Баннер успешно загружен: $ad');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ошибка загрузки баннера: $error');
          ad.dispose();
          _bannerAd = null;
        },
      ),
    );
    _bannerAd?.load();
  }

  BannerAd? get bannerAd => _bannerAd;

  void _loadInterstitialAd() {
    if (_isAdLoading || _interstitialAd != null) return;

    _isAdLoading = true;
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3677409032346147/3968532801',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoading = false;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Ошибка загрузки интерстициальной рекламы: $error');
          _interstitialAd = null;
          _isAdLoading = false;
          _numInterstitialLoadAttempts++;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            Future.delayed(const Duration(seconds: 3), _loadInterstitialAd);
          }
        },
      ),
    );
  }

  void showInterstitialAd({required Function onAdClosed}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _interstitialAd = null;
          _loadInterstitialAd();
          onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _interstitialAd = null;
          print('Ошибка отображения интерстициальной рекламы: $error');
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
    } else {
      print('Интерстициальная реклама еще не загружена.');
      _loadInterstitialAd();
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
    _bannerAd?.dispose();
  }
}

final adsServiceProvider = Provider<AdsService>((ref) => AdsService());
