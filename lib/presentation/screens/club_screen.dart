import 'dart:io';

import 'package:flutter/material.dart';
import 'package:football_stadium/presentation/screens/stadium_screen.dart';
import 'package:football_stadium/utils/ad_helper.dart';
import 'package:football_stadium/utils/scroll_behaviour.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class ClubScreen extends StatefulWidget {
  const ClubScreen({super.key});

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool isInterstitialAdLoaded = false;

  void _loadBannerAd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Get.to(() => StadiumScreen(), transition: Transition.rightToLeft);
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('error interstitial ad');
        },
      ),
    );
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  void initState() {
    super.initState();
    _initGoogleMobileAds();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTitle() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'English Premier League',
            style: boldTextStyle.copyWith(color: whiteColor, fontSize: 18),
          ),
          const SizedBox(height: 2),
          Text(
            'Stadium Totals : 20',
            style: mediumTextStyle.copyWith(color: whiteColor, fontSize: 12),
          ),
        ],
      );
    }

    Widget buildButton() {
      return TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios, color: whiteColor, size: 20),
      );
    }

    Widget buildLogo() {
      return Container(
        padding: const EdgeInsets.only(right: 12, left: 4),
        child: Image.asset("assets/images/logo/leagues/epl.png", width: 25),
      );
    }

    Widget buildStadiums() {
      List<String> stadiumLogos = [
        "assets/images/logo/teams/manchester_united.png",
        "assets/images/logo/teams/manchester_city.png",
        "assets/images/logo/teams/chelsea.png",
      ];
      List<String> stadiumNames = [
        "Old Trafford",
        "Etihad Stadium",
        "Stamford Bridge",
      ];
      List<String> stadiumCapacities = ["70.000", "74.310", "81.365"];
      List<String> stadiumClubs = [
        "Manchester United",
        "Manchester City",
        "Chelsea F.C",
      ];

      return Container(
        padding: const EdgeInsets.only(top: 16, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 24, bottom: 24),
              child: Text(
                'Select club to see details',
                style: mediumTextStyle.copyWith(color: whiteColor),
              ),
            ),
            Shimmer.fromColors(
              baseColor: secondaryColor,
              highlightColor: thirdColor,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                  mainAxisExtent: 80,
                ),
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                  );
                },
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                mainAxisExtent: 80,
              ),
              itemCount: stadiumLogos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (!isInterstitialAdLoaded) {
                      if (_interstitialAd != null) {
                        _interstitialAd?.show();
                        setState(() {
                          isInterstitialAdLoaded = true;
                        });
                      } else {
                        Get.to(
                          () => StadiumScreen(),
                          transition: Transition.rightToLeft,
                        );
                        setState(() {
                          isInterstitialAdLoaded = true;
                        });
                      }
                    } else {
                      Get.to(
                        () => StadiumScreen(),
                        transition: Transition.rightToLeft,
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: secondaryColor,
                      border: Border(
                        top: BorderSide(
                          color: index == 0 ? primaryColor : thirdColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 12),
                              child: Image.asset(
                                stadiumLogos[index],
                                width: 30,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  stadiumClubs[index],
                                  style: semiBoldTextStyle.copyWith(
                                    color: whiteColor,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  stadiumNames[index],
                                  style: mediumTextStyle.copyWith(
                                    color: whiteColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          "Capacity: ${stadiumCapacities[index]}",
                          style: mediumTextStyle.copyWith(
                            color: whiteColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    Widget buildContent() {
      double paddingTop = 0;

      if (Platform.isAndroid) {
        paddingTop = 24;
      }

      return Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: paddingTop),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buildButton(), buildLogo(), buildTitle()],
            ),
          ),
          buildStadiums(),
        ],
      );
    }

    Widget buildBannerAds() {
      return (_bannerAd != null)
          ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10, top: 24),
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          )
          : Container();
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehaviour(),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [buildContent(), buildBannerAds()]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
