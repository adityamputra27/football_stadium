import 'package:flutter/material.dart';
import 'package:football_stadium/presentation/screens/club_screen.dart';
import 'package:football_stadium/utils/ad_helper.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class LeagueScreen extends StatefulWidget {
  const LeagueScreen({super.key});

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> {
  int selectedLeague = 0;
  BannerAd? _bannerAd;

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

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  void initState() {
    super.initState();
    _initGoogleMobileAds();
    _loadBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> leagueLogos = [
      "assets/images/logo/leagues/epl.png",
      "assets/images/logo/leagues/laliga.png",
      "assets/images/logo/leagues/serie_a.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/epl.png",
      "assets/images/logo/leagues/laliga.png",
      "assets/images/logo/leagues/serie_a.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/epl.png",
      "assets/images/logo/leagues/laliga.png",
      "assets/images/logo/leagues/serie_a.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/epl.png",
      "assets/images/logo/leagues/laliga.png",
      "assets/images/logo/leagues/serie_a.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/briliga1.png",
    ];

    Widget buildListLeagues() {
      // return Shimmer.fromColors(
      //   baseColor: secondaryColor,
      //   highlightColor: thirdColor,
      //   child: GridView.builder(
      //     shrinkWrap: true,
      //     padding: EdgeInsets.only(top: 24, bottom: 24),
      //     physics: NeverScrollableScrollPhysics(),
      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 4,
      //       crossAxisSpacing: 10,
      //       mainAxisSpacing: 10,
      //       childAspectRatio: 1,
      //       mainAxisExtent: 100,
      //     ),
      //     itemCount: 20,
      //     itemBuilder: (context, index) {
      //       return Container(
      //         decoration: BoxDecoration(
      //           color: secondaryColor,
      //           borderRadius: BorderRadius.all(Radius.circular(24)),
      //         ),
      //       );
      //     },
      //   ),
      // );

      return GridView.builder(
        padding: EdgeInsets.only(top: 24, bottom: 24),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
          mainAxisExtent: 100,
        ),
        itemCount: leagueLogos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedLeague = index;
              });

              Get.to(() => ClubScreen(), transition: Transition.rightToLeft);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 2,
                    color: selectedLeague == index ? primaryColor : thirdColor,
                  ),
                  bottom: BorderSide(
                    width: 2,
                    color: selectedLeague == index ? primaryColor : thirdColor,
                  ),
                  left: BorderSide(
                    width: 2,
                    color: selectedLeague == index ? primaryColor : thirdColor,
                  ),
                  right: BorderSide(
                    width: 2,
                    color: selectedLeague == index ? primaryColor : thirdColor,
                  ),
                ),
                borderRadius: BorderRadius.circular(24),
                color: secondaryColor,
              ),
              padding: EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 20,
                ),
                width: 10,
                child: Image.asset(leagueLogos[index]),
              ),
            ),
          );
        },
      );
    }

    Widget buildTitle() {
      return Text(
        'Select League',
        style: boldTextStyle.copyWith(color: whiteColor, fontSize: 18),
      );
    }

    Widget buildBannerAds() {
      return (_bannerAd != null)
          ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          )
          : Container();
    }

    Widget buildContent() {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [buildTitle(), buildListLeagues(), buildBannerAds()],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [Expanded(child: SingleChildScrollView(child: buildContent()))],
    );
  }
}
