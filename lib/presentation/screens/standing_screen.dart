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

class StandingScreen extends StatefulWidget {
  final int footballLeagueId;
  final String footballLeagueLogo;
  final String footballLeagueName;
  final int footballClubTotal;

  const StandingScreen({
    super.key,
    required this.footballLeagueId,
    required this.footballLeagueLogo,
    required this.footballLeagueName,
    this.footballClubTotal = 0,
  });

  @override
  State<StandingScreen> createState() => _StandingScreenState();
}

class _StandingScreenState extends State<StandingScreen> {
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
            'Standings Table',
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

    Widget buildStandings() {
      Widget buildCell(String text) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Text(
            text,
            style: semiBoldTextStyle.copyWith(fontSize: 12, color: whiteColor),
          ),
        );
      }

      Widget buildClubCell(String clubName) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Row(
            children: [
              Icon(
                Icons.sports_soccer,
                color: Colors.white,
                size: 16,
              ), // bisa ganti Icon lain jika perlu
              const SizedBox(width: 8),
              Text(
                clubName,
                style: semiBoldTextStyle.copyWith(
                  fontSize: 12,
                  color: whiteColor,
                ),
              ),
            ],
          ),
        );
      }

      final List<TableRow> standingRows = [
        TableRow(
          children: [
            buildCell('1'),
            buildClubCell('Manchester City'),
            buildCell('32'),
            buildCell('25'),
            buildCell('5'),
            buildCell('2'),
            buildCell('80'),
          ],
        ),
        TableRow(
          children: [
            buildCell('2'),
            buildClubCell('Arsenal'),
            buildCell('32'),
            buildCell('24'),
            buildCell('4'),
            buildCell('4'),
            buildCell('76'),
          ],
        ),
        TableRow(
          children: [
            buildCell('3'),
            buildClubCell('Liverpool'),
            buildCell('32'),
            buildCell('23'),
            buildCell('6'),
            buildCell('3'),
            buildCell('75'),
          ],
        ),
        TableRow(
          children: [
            buildCell('4'),
            buildClubCell('Tottenham'),
            buildCell('32'),
            buildCell('19'),
            buildCell('7'),
            buildCell('6'),
            buildCell('64'),
          ],
        ),
        TableRow(
          children: [
            buildCell('5'),
            buildClubCell('Aston Villa'),
            buildCell('32'),
            buildCell('18'),
            buildCell('8'),
            buildCell('6'),
            buildCell('62'),
          ],
        ),
        TableRow(
          children: [
            buildCell('6'),
            buildClubCell('Chelsea'),
            buildCell('32'),
            buildCell('16'),
            buildCell('9'),
            buildCell('7'),
            buildCell('57'),
          ],
        ),
        TableRow(
          children: [
            buildCell('7'),
            buildClubCell('Newcastle Utd'),
            buildCell('32'),
            buildCell('15'),
            buildCell('9'),
            buildCell('8'),
            buildCell('54'),
          ],
        ),
        TableRow(
          children: [
            buildCell('8'),
            buildClubCell('Man United'),
            buildCell('32'),
            buildCell('15'),
            buildCell('7'),
            buildCell('10'),
            buildCell('52'),
          ],
        ),
        TableRow(
          children: [
            buildCell('9'),
            buildClubCell('Brighton'),
            buildCell('32'),
            buildCell('13'),
            buildCell('10'),
            buildCell('9'),
            buildCell('49'),
          ],
        ),
        TableRow(
          children: [
            buildCell('10'),
            buildClubCell('West Ham United'),
            buildCell('32'),
            buildCell('13'),
            buildCell('8'),
            buildCell('11'),
            buildCell('47'),
          ],
        ),
        TableRow(
          children: [
            buildCell('11'),
            buildClubCell('Wolves'),
            buildCell('32'),
            buildCell('12'),
            buildCell('9'),
            buildCell('11'),
            buildCell('45'),
          ],
        ),
        TableRow(
          children: [
            buildCell('12'),
            buildClubCell('Fulham'),
            buildCell('32'),
            buildCell('11'),
            buildCell('8'),
            buildCell('13'),
            buildCell('41'),
          ],
        ),
        TableRow(
          children: [
            buildCell('13'),
            buildClubCell('Crystal Palace'),
            buildCell('32'),
            buildCell('10'),
            buildCell('9'),
            buildCell('13'),
            buildCell('39'),
          ],
        ),
        TableRow(
          children: [
            buildCell('14'),
            buildClubCell('Everton'),
            buildCell('32'),
            buildCell('9'),
            buildCell('10'),
            buildCell('13'),
            buildCell('37'),
          ],
        ),
        TableRow(
          children: [
            buildCell('15'),
            buildClubCell('Brentford'),
            buildCell('32'),
            buildCell('8'),
            buildCell('11'),
            buildCell('13'),
            buildCell('35'),
          ],
        ),
        TableRow(
          children: [
            buildCell('16'),
            buildClubCell('Nott Forest'),
            buildCell('32'),
            buildCell('8'),
            buildCell('9'),
            buildCell('15'),
            buildCell('33'),
          ],
        ),
        TableRow(
          children: [
            buildCell('17'),
            buildClubCell('Luton Town'),
            buildCell('32'),
            buildCell('7'),
            buildCell('10'),
            buildCell('15'),
            buildCell('31'),
          ],
        ),
        TableRow(
          children: [
            buildCell('18'),
            buildClubCell('Burnley'),
            buildCell('32'),
            buildCell('6'),
            buildCell('9'),
            buildCell('17'),
            buildCell('27'),
          ],
        ),
        TableRow(
          children: [
            buildCell('19'),
            buildClubCell('Sheffield United'),
            buildCell('32'),
            buildCell('4'),
            buildCell('8'),
            buildCell('20'),
            buildCell('20'),
          ],
        ),
        TableRow(
          children: [
            buildCell('20'),
            buildClubCell('Bournemouth'),
            buildCell('32'),
            buildCell('3'),
            buildCell('10'),
            buildCell('19'),
            buildCell('19'),
          ],
        ),
      ];

      return Container(
        padding: const EdgeInsets.only(top: 16, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 16, bottom: 24),
              child: Text(
                'Active Season : 2024/2025 | Week : 32',
                style: mediumTextStyle.copyWith(color: whiteColor),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                width: MediaQuery.of(context).size.width,
                child: Table(
                  columnWidths: const {
                    0: FixedColumnWidth(40), // Pos
                    1: FlexColumnWidth(), // Club
                    2: FixedColumnWidth(40), // P
                    3: FixedColumnWidth(40), // W
                    4: FixedColumnWidth(40), // D
                    5: FixedColumnWidth(40), // L
                    6: FixedColumnWidth(40), // Pts
                  },
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 8,
                          ),
                          child: Text(
                            'Pos',
                            style: semiBoldTextStyle.copyWith(
                              color: whiteColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 8,
                          ),
                          child: Text(
                            'Club',
                            style: semiBoldTextStyle.copyWith(
                              color: whiteColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 8,
                          ),
                          child: Text(
                            'P',
                            style: semiBoldTextStyle.copyWith(
                              color: whiteColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 8,
                          ),
                          child: Text(
                            'W',
                            style: semiBoldTextStyle.copyWith(
                              color: whiteColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 8,
                          ),
                          child: Text(
                            'D',
                            style: semiBoldTextStyle.copyWith(
                              color: whiteColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 8,
                          ),
                          child: Text(
                            'L',
                            style: semiBoldTextStyle.copyWith(
                              color: whiteColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 8,
                          ),
                          child: Text(
                            'Pts',
                            style: semiBoldTextStyle.copyWith(
                              color: whiteColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Data Rows
                    ...standingRows,
                  ],
                ),
              ),
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
          buildStandings(),
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
