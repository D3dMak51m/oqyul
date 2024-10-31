import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marquee/marquee.dart';
import '../services/ads_service.dart';

class BannerAdWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsService = ref.watch(adsServiceProvider);
    final bannerAd = adsService.bannerAd;

    if (bannerAd == null) {
      print('Баннер не загружен');
      return Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue,
        child:   Marquee(
          text: 'Здесь могла быть ваша реклама.',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          blankSpace: 20.0,
          velocity: 50.0,
          // pauseAfterRound: Duration(seconds: 0),
          startPadding: 10.0,
          // accelerationDuration: Duration(seconds: 0),
          accelerationCurve: Curves.linear,
          // decelerationDuration: Duration(milliseconds: 500),
          // decelerationCurve: Curves.easeOut,
        ),

      ); // Пустое место, если баннер не загружен
    }

    return Container(
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
      alignment: Alignment.center,
      child: AdWidget(ad: bannerAd),
    );
  }
}
