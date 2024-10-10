import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:oqyul/services/ad_service.dart';
import 'package:oqyul/widgets/premium_progress_bar.dart';
import 'package:oqyul/widgets/update_database_button.dart';
import '../../blocs/premium/premium_bloc.dart';
import 'map_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AdService adService = AdService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Oqyul'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MapScreen(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                UpdateDatabaseButton(),
                // ExtendPremiumButton(),
                BlocBuilder<PremiumBloc, PremiumState>(
                  builder: (context, state) {
                    if (state is PremiumActive) {
                      return PremiumProgressBar(expiryDate: state.expiryDate);
                    } else if (state is PremiumAdsInProgress) {
                      return LinearProgressIndicator(
                        value: state.adsWatched / 6,
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
                Container(
                  height: 50,
                  child: adService.bannerAd != null
                      ? AdWidget(ad: adService.bannerAd!)
                      : SizedBox.shrink(), // Или любой другой виджет-заглушка
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
