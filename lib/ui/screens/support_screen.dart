import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/main.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ModalRoute.of(context).settings.name.substring(1),
        ),
        elevation: 0,
      ),
      body: Container(
        child: AdmobBanner(
          adUnitId: getBannerAdUnitId(),
          adSize: AdmobBannerSize.FULL_BANNER,
        ),
      ),
      bottomSheet: AdmobBanner(
        adUnitId: getBannerAdUnitId(),
        adSize: AdmobBannerSize.SMART_BANNER,
      ),
    );
  }

  Future<void> _initialize() async {
    AdmobInterstitial interstitialAd = AdmobInterstitial(
      adUnitId: getBannerAdUnitId(),
    );

    interstitialAd.load();

    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    }

    interstitialAd.dispose();
  }
}
