import 'dart:io';
import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/main.dart';
import 'package:thi_trac_nghiem/ui/widget/common_drawer.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  List<AdmobBannerSize> _admobBannerSizes = Platform.isAndroid
      ? <AdmobBannerSize>[
//          AdmobBannerSize.MEDIUM_RECTANGLE,
//          AdmobBannerSize.LARGE_BANNER,
//          AdmobBannerSize.BANNER,
//          AdmobBannerSize.LEADERBOARD,
//          AdmobBannerSize.FULL_BANNER,
        ]
      : <AdmobBannerSize>[];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _autoShowFullScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ModalRoute
              .of(context)
              .settings
              .name
              .substring(1),
        ),
        elevation: 0,
      ),
      drawer: CommonDrawer(),
      body: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (index == 0) {
                  return Center(
                    child: FlatButton(
                      onPressed: () => _showFullScreenAds(),
                      color: Colors.blue,
                      child: Text(
                        'Hiển thị quảng cáo',
                      ),
                    ),
                  );
                }
                return _createBannerAd(index - 1);
              },
              childCount: _admobBannerSizes.length + 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createBannerAd(final int index) {
    return AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: _admobBannerSizes[index],
    );
  }

  Future<void> _showFullScreenAds() async {
    final boolean = Random().nextBool();
    if (boolean) {
      if (await interstitialAd.isLoaded) {
        interstitialAd.show();
      } else if (await rewardAd.isLoaded) {
        rewardAd.show();
      }
    } else {
      if (await rewardAd.isLoaded) {
        rewardAd.show();
      } else if (await interstitialAd.isLoaded) {
        interstitialAd.show();
      }
    }
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    rewardAd.dispose();
    super.dispose();
  }

  Future<void> _autoShowFullScreen() async {
    while (!await interstitialAd.isLoaded && !await rewardAd.isLoaded) {
      await Future.delayed(
        Duration(milliseconds: 100),
      );
    }
    _showFullScreenAds();
  }
}
