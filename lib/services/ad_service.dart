import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService extends ChangeNotifier {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();
  final String bannerAdUnitId = 'ca-app-pub-3677409032346147/2655089746';
  final String rewardedAdUnitId = 'ca-app-pub-3677409032346147/3968532801';
  BannerAd? _bannerAd;
  RewardedAd? _rewardedAd;
  RewardedAd? get rewardedAd => _rewardedAd;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    loadBannerAd();
    loadRewardedAd();
  }

  // Загрузка баннерной рекламы
  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Баннерная реклама загружена');
          notifyListeners();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ошибка загрузки баннерной рекламы: $error');
          _bannerAd = null;
          notifyListeners();
        },
      ),
    )..load();
  }

  // Получение баннерной рекламы
  BannerAd? get bannerAd => _bannerAd;

  // Загрузка вознаграждаемой рекламы
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          print('Вознаграждаемая реклама загружена');
          notifyListeners();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Ошибка загрузки вознаграждаемой рекламы: $error');
          _rewardedAd = null;
          notifyListeners();
        },
      ),
    );
  }

  // Показ вознаграждаемой рекламы
  void showRewardedAd(Function(RewardItem) onUserEarnedReward, Function() onAdDismissed) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          onAdDismissed();
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          print('Ошибка показа вознаграждаемой рекламы: $error');
          _rewardedAd = null;
          notifyListeners();
          loadRewardedAd();
        },
      );

      _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        onUserEarnedReward(reward);
      });
      _rewardedAd = null;
    } else {
      print('Вознаграждаемая реклама не загружена');
    }
  }
}
