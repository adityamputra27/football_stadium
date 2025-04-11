import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:football_stadium/data/models/football_club_model.dart';
import 'package:football_stadium/presentation/screens/stadium_screen.dart';
import 'package:football_stadium/presentation/widgets/shimmers/card_row_shimmer.dart';
import 'package:football_stadium/utils/ad_helper.dart';
import 'package:football_stadium/utils/environment.dart';
import 'package:football_stadium/utils/scroll_behaviour.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

class ClubScreen extends StatefulWidget {
  final int footballLeagueId;
  final String footballLeagueLogo;
  final String footballLeagueName;
  final int footballClubTotal;

  const ClubScreen({
    super.key,
    required this.footballLeagueId,
    required this.footballLeagueLogo,
    required this.footballLeagueName,
    this.footballClubTotal = 0,
  });

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool isInterstitialAdLoaded = false;
  List<FootballClubModel> footballClubs = [];
  bool isLoading = true;
  FootballClubModel? selectedFootballClub;

  Future<void> fetchFootballClubs() async {
    final response = await http.get(
      Uri.parse("${Environment.baseURL}/all-clubs/${widget.footballLeagueId}"),
      headers: {'Football-Stadium-App': Environment.valueHeader},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body)['data']['data'];
      setState(() {
        footballClubs =
            (jsonData as List)
                .map((data) => FootballClubModel.fromJson(data))
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
                () => StadiumScreen(
                  footballClubId: selectedFootballClub!.footballClubId,
                  footballLeagueId: widget.footballLeagueId,
                  footballClubLogo: selectedFootballClub!.logoWhite,
                  footballClubName: selectedFootballClub!.clubName,
                  footballStadiumName: selectedFootballClub!.stadiumName!,
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
    fetchFootballClubs();
  }

  @override
  void dispose() {
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
            widget.footballLeagueName,
            style: boldTextStyle.copyWith(color: whiteColor, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            'Stadium total : ${widget.footballClubTotal}',
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
        child: Image.network(widget.footballLeagueLogo, width: 25),
      );
    }

    Widget buildStadiums() {
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
            isLoading
                ? CardRowShimmer(itemCount: 10)
                : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                    mainAxisExtent: 70,
                  ),
                  itemCount: footballClubs.length,
                  itemBuilder: (context, index) {
                    FootballClubModel footballClub = footballClubs[index];

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
                              () => StadiumScreen(
                                footballClubId: footballClub.footballClubId,
                                footballLeagueId: widget.footballLeagueId,
                                footballClubLogo: footballClub.logoWhite,
                                footballClubName: footballClub.clubName,
                                footballStadiumName: footballClub.stadiumName!,
                              ),
                              transition: Transition.rightToLeft,
                            );
                            setState(() {
                              isInterstitialAdLoaded = true;
                            });
                          }
                        } else {
                          Get.to(
                            () => StadiumScreen(
                              footballClubId: footballClub.footballClubId,
                              footballLeagueId: widget.footballLeagueId,
                              footballClubName: footballClub.clubName,
                              footballClubLogo: footballClub.logoWhite,
                              footballStadiumName: footballClub.stadiumName!,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        }

                        setState(() {
                          selectedFootballClub = footballClub;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: adjustColor(secondaryColor),
                          border: Border(
                            top: BorderSide(
                              color:
                                  index == 0
                                      ? adjustColor(primaryColor)
                                      : adjustColor(thirdColor),
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
                                  child: Image.network(
                                    footballClub.logoWhite,
                                    width: 22,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      footballClub.clubName,
                                      style: semiBoldTextStyle.copyWith(
                                        color: whiteColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      footballClub.stadiumName!,
                                      style: mediumTextStyle.copyWith(
                                        color: whiteColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              "Capacity: ${footballClub.capacity}",
                              style: mediumTextStyle.copyWith(
                                color: whiteColor,
                                fontSize: 10,
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
        paddingTop = 18;
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
      backgroundColor: adjustColor(backgroundColor),
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
