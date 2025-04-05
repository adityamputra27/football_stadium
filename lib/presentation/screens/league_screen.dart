import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:football_stadium/data/models/football_league_model.dart';
import 'package:football_stadium/presentation/screens/club_screen.dart';
import 'package:football_stadium/presentation/widgets/shimmers/card_grid_shimmer.dart';
import 'package:football_stadium/utils/ad_helper.dart';
import 'package:football_stadium/utils/environment.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

class LeagueScreen extends StatefulWidget {
  const LeagueScreen({super.key});

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> {
  int selectedLeague = 0;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool isInterstitialAdLoaded = false;

  List<FootballLeagueModel> footballLeagues = [];
  FootballLeagueModel? selectedFootballLeague;
  bool isLoading = true;

  Future<void> fetchFootballLeagues() async {
    final response = await http.get(
      Uri.parse("${Environment.baseURL}/all-leagues/"),
      headers: {'Football-Stadium-App': Environment.valueHeader},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body)['data']['data'];
      setState(() {
        footballLeagues =
            (jsonData as List)
                .map((data) => FootballLeagueModel.fromJson(data))
                .toList();

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }
  }

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
              Get.to(
                () => ClubScreen(
                  footballLeagueId: selectedFootballLeague!.id,
                  footballLeagueLogo: selectedFootballLeague!.logoWhite,
                  footballLeagueName: selectedFootballLeague!.name,
                  footballClubTotal: selectedFootballLeague!.clubTotal,
                ),
                transition: Transition.rightToLeft,
              );
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

    // for fetching data API's
    fetchFootballLeagues();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildListLeagues() {
      return isLoading
          ? CardGridShimmer(itemCount: 20)
          : GridView.builder(
            padding: EdgeInsets.only(top: 24, bottom: 24),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
              mainAxisExtent: 95,
            ),
            itemCount: footballLeagues.length,
            itemBuilder: (context, index) {
              FootballLeagueModel footballLeague = footballLeagues[index];
              return GestureDetector(
                onTap: () {
                  if (!isInterstitialAdLoaded) {
                    if (_interstitialAd != null) {
                      _interstitialAd!.show();
                      setState(() {
                        isInterstitialAdLoaded = true;
                      });
                    } else {
                      setState(() {
                        isInterstitialAdLoaded = true;
                      });
                      Get.to(
                        () => ClubScreen(
                          footballLeagueId: footballLeague.id,
                          footballLeagueLogo: footballLeague.logoWhite,
                          footballLeagueName: footballLeague.name,
                          footballClubTotal: footballLeague.clubTotal,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    }
                  } else {
                    Get.to(
                      () => ClubScreen(
                        footballLeagueId: footballLeague.id,
                        footballLeagueLogo: footballLeague.logoWhite,
                        footballLeagueName: footballLeague.name,
                        footballClubTotal: footballLeague.clubTotal,
                      ),
                      transition: Transition.rightToLeft,
                    );
                  }

                  setState(() {
                    selectedFootballLeague = footballLeague;
                    selectedLeague = index;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 2,
                        color:
                            selectedLeague == index
                                ? primaryColor
                                : adjustColor(thirdColor),
                      ),
                      bottom: BorderSide(
                        width: 2,
                        color:
                            selectedLeague == index
                                ? primaryColor
                                : adjustColor(thirdColor),
                      ),
                      left: BorderSide(
                        width: 2,
                        color:
                            selectedLeague == index
                                ? primaryColor
                                : adjustColor(thirdColor),
                      ),
                      right: BorderSide(
                        width: 2,
                        color:
                            selectedLeague == index
                                ? primaryColor
                                : adjustColor(thirdColor),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(18),
                    color: adjustColor(secondaryColor),
                  ),
                  padding: EdgeInsets.all(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    width: 10,
                    child: Image.network(footballLeague.logoWhite),
                  ),
                ),
              );
            },
          );
    }

    Widget buildTitle() {
      return Text(
        'Select League',
        style: boldTextStyle.copyWith(color: whiteColor, fontSize: 16),
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
