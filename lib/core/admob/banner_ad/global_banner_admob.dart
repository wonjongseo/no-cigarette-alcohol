import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:no_cigarette_alcohol/core/admob/ad_unit_id.dart';

class GlobalBannerAdmob extends StatefulWidget {
  const GlobalBannerAdmob({super.key, this.widgets});
  final List<Widget>? widgets;
  @override
  State<StatefulWidget> createState() {
    return _GlobalBannerAdmobState();
  }
}

class _GlobalBannerAdmobState extends State<GlobalBannerAdmob> {
  BannerAd? _bannerAd;
  AdUnitId adUnitId = AdUnitId();
  bool _bannerReady = false;

  @override
  void initState() {
    super.initState();

    initAdMob();
  }

  void initAdMob() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId.banner[GetPlatform.isIOS ? 'ios' : 'android']!,
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _bannerReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          setState(() {
            _bannerReady = false;
          });
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.widgets != null) ...[
            ...widget.widgets!,
            SizedBox(height: 10),
          ],
          if (_bannerAd == null) //|| !kReleaseMode
            Container(height: 0)
          else
            _bannerReady
                ? SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                )
                : Container(height: 0),
        ],
      ),
    );
  }
}
