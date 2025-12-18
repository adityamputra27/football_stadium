import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:football_stadium/data/models/football_league_model.dart';
import 'package:football_stadium/presentation/screens/club_screen.dart';
import 'package:football_stadium/presentation/screens/standing_screen.dart';
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
                () => StandingScreen(
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
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
              mainAxisExtent: 90,
            ),
            itemCount: footballLeagues.length,
            itemBuilder: (context, index) {
              FootballLeagueModel footballLeague = footballLeagues[index];
              return GestureDetector(
                onTap: () {
                  // Get.to(
                  //   () => ClubScreen(
                  //     footballLeagueId: footballLeague.id,
                  //     footballLeagueLogo: footballLeague.logoWhite,
                  //     footballLeagueName: footballLeague.name,
                  //     footballClubTotal: footballLeague.clubTotal,
                  //   ),
                  //   transition: Transition.rightToLeft,
                  // );

                  setState(() {
                    selectedFootballLeague = footballLeague;
                    selectedLeague = index;
                  });

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: adjustColor(backgroundColor),
                        content: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (selectedFootballLeague != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      children: [
                                        Image.network(
                                          selectedFootballLeague!.logoWhite,
                                          width: 25,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          selectedFootballLeague!.name,
                                          style: boldTextStyle.copyWith(
                                            color: whiteColor,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 24,
                                    bottom: 24,
                                  ),
                                  child: Text(
                                    'Active Season : 2024/2025',
                                    style: semiBoldTextStyle.copyWith(
                                      color: whiteColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.to(
                                            () => ClubScreen(
                                              footballLeagueId:
                                                  footballLeague.id,
                                              footballLeagueLogo:
                                                  footballLeague.logoWhite,
                                              footballLeagueName:
                                                  footballLeague.name,
                                              footballClubTotal:
                                                  footballLeague.clubTotal,
                                            ),
                                            transition: Transition.rightToLeft,
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.sports_soccer,
                                              color: whiteColor,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Football Clubs',
                                              style: boldTextStyle.copyWith(
                                                color: whiteColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: () {
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
                                                () => StandingScreen(
                                                  footballLeagueId:
                                                      footballLeague.id,
                                                  footballLeagueLogo:
                                                      footballLeague.logoWhite,
                                                  footballLeagueName:
                                                      footballLeague.name,
                                                  footballClubTotal:
                                                      footballLeague.clubTotal,
                                                ),
                                                transition:
                                                    Transition.rightToLeft,
                                              );
                                            }
                                          } else {
                                            Get.to(
                                              () => StandingScreen(
                                                footballLeagueId:
                                                    footballLeague.id,
                                                footballLeagueLogo:
                                                    footballLeague.logoWhite,
                                                footballLeagueName:
                                                    footballLeague.name,
                                                footballClubTotal:
                                                    footballLeague.clubTotal,
                                              ),
                                              transition:
                                                  Transition.rightToLeft,
                                            );
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.leaderboard,
                                              color: whiteColor,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Football Standings',
                                              style: boldTextStyle.copyWith(
                                                color: whiteColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: () {
                                          // Navigasi ke MatchesScreen
                                          // Get.to(
                                          //   () => MatchesScreen(),
                                          //   transition: Transition.rightToLeft,
                                          // );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.event,
                                              color: whiteColor,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Football Matches',
                                              style: boldTextStyle.copyWith(
                                                color: whiteColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: SizedBox(
                                        width: 120,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Close',
                                            style: boldTextStyle.copyWith(
                                              color: whiteColor,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
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
                      vertical: 16,
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
