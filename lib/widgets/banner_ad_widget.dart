import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ads_service.dart';

class BannerAdWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsService = ref.watch(adsServiceProvider);
    final bannerAd = adsService.bannerAd;

    if (bannerAd == null) {
      print('Баннер не загружен');
      return const SizedBox.shrink(); // Пустое место, если баннер не загружен
    }

    return Container(
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
      alignment: Alignment.center,
      child: AdWidget(ad: bannerAd),
    );
  }
}
