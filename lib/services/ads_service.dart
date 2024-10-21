import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  InterstitialAd? _interstitialAd;
  bool _isAdLoading = false;
  int _numInterstitialLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    loadInterstitialAd();
  }

  void loadInterstitialAd() {
    if (_isAdLoading || _interstitialAd != null) {
      return;
    }

    _isAdLoading = true;

    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3677409032346147/3968532801',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoading = false;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _interstitialAd = null;
          _isAdLoading = false;
          _numInterstitialLoadAttempts += 1;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            Future.delayed(Duration(seconds: 3), loadInterstitialAd);
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
          loadInterstitialAd();
          onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _interstitialAd = null;
          print('InterstitialAd failed to show: $error');
          loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
    } else {
      print('Реклама еще не загружена. Загрузка...');
      loadInterstitialAd();
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}

final adsServiceProvider = Provider((ref) => AdsService());
