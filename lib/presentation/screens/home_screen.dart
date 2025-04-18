import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:football_stadium/data/models/main_model.dart';
import 'package:football_stadium/presentation/screens/club_screen.dart';
import 'package:football_stadium/presentation/screens/stadium_screen.dart';
import 'package:football_stadium/presentation/widgets/shimmers/card_grid_shimmer.dart';
import 'package:football_stadium/presentation/widgets/shimmers/card_row_shimmer.dart';
import 'package:football_stadium/presentation/widgets/shimmers/carousel_shimmer.dart';
import 'package:football_stadium/utils/ad_helper.dart';
import 'package:football_stadium/utils/environment.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/route_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CarouselSliderController innerCarouselController;
  int innerSliderIndex = 0;
  int selectedLeague = 0;
  BannerAd? _bannerAd;
  bool isLoading = true;
  MainModel? mainData;

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

  Future<void> fetchMainScreen() async {
    final response = await http.get(
      Uri.parse("${Environment.baseURL}/main-screen-user/"),
      headers: {'Football-Stadium-App': Environment.valueHeader},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body)['data']['data'];
      List<MainPopularStadium> popularStadiums =
          (jsonData['popular_stadiums'] as List)
              .map((stadium) => MainPopularStadium.fromJson(stadium))
              .toList();

      List<MainPopularLeague> popularLeagues =
          (jsonData['popular_leagues'] as List)
              .map((league) => MainPopularLeague.fromJson(league))
              .toList();

      List<MainPopularClub> popularClubs =
          (jsonData['popular_clubs'] as List)
              .map((league) => MainPopularClub.fromJson(league))
              .toList();

      setState(() {
        mainData = MainModel(
          popularStadiums: popularStadiums,
          popularLeagues: popularLeagues,
          popularClubs: popularClubs,
        );
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    innerCarouselController = CarouselSliderController();

    _initGoogleMobileAds();
    _loadBannerAd();

    // for fetching data API's
    fetchMainScreen();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildCarousel() {
      return isLoading
          ? CarouselShimmer()
          : ListView(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: Platform.isIOS ? 6 : 12,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: CarouselSlider.builder(
                        itemCount: mainData?.popularStadiums.length,
                        carouselController: innerCarouselController,
                        itemBuilder: (
                          BuildContext context,
                          int index,
                          int realIndex,
                        ) {
                          MainPopularStadium? popularStadium =
                              mainData?.popularStadiums[index];
                          return SizedBox(
                            child: Stack(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(14),
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                            popularStadium!.stadiumFilePath!,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: primaryColor,
                                            width: 1.5,
                                          ),
                                        ),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(14),
                                        ),
                                        gradient: LinearGradient(
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            backgroundColor,
                                          ],
                                          stops: [0.0, 0.85],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 12,
                                    top: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Capacity : ${popularStadium.capacity}",
                                        style: mediumTextStyle.copyWith(
                                          fontSize: 12,
                                          color: whiteColor,
                                        ),
                                      ),
                                      // isRenovations[index]
                                      //     ? Container(
                                      //       decoration: BoxDecoration(
                                      //         color: primaryColor,
                                      //         borderRadius: BorderRadius.all(
                                      //           Radius.circular(8),
                                      //         ),
                                      //       ),
                                      //       padding: const EdgeInsets.only(
                                      //         top: 4,
                                      //         bottom: 6,
                                      //         right: 8,
                                      //         left: 8,
                                      //       ),
                                      //       child: Text(
                                      //         'Renovation'.toUpperCase(),
                                      //         style: boldTextStyle.copyWith(
                                      //           color: whiteColor,
                                      //           fontSize: 10,
                                      //         ),
                                      //       ),
                                      //     )
                                      //     : const SizedBox(),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 2,
                                        ),
                                        child: Image.network(
                                          popularStadium.logoPrimary,
                                          width: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            popularStadium.clubName,
                                            style: semiBoldTextStyle.copyWith(
                                              color: whiteColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            popularStadium.stadiumName!,
                                            style: mediumTextStyle.copyWith(
                                              color: whiteColor,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 180,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          enableInfiniteScroll: true,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              innerSliderIndex = index;
                            });
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * .045,
                      right: MediaQuery.of(context).size.height * .015,
                      child: Row(
                        children: List.generate(
                          mainData!.popularStadiums.length,
                          (index) {
                            bool isSelected = innerSliderIndex == index;
                            return GestureDetector(
                              onTap: () {},
                              child: AnimatedContainer(
                                width: 6,
                                height: 6,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? dotIndicatorActiveColor
                                          : dotIndicatorDefaultColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                duration: const Duration(milliseconds: 300),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
    }

    Widget buildPopularLeague() {
      double paddingTop = 8;
      if (Platform.isIOS) {
        paddingTop = 14;
      }

      return Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: paddingTop),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Popular League',
              style: boldTextStyle.copyWith(color: whiteColor, fontSize: 16),
            ),

            isLoading
                ? CardGridShimmer()
                : GridView.builder(
                  padding: EdgeInsets.only(top: 24),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                    mainAxisExtent: 90,
                  ),
                  itemCount: mainData?.popularLeagues.length,
                  itemBuilder: (context, index) {
                    MainPopularLeague popularLeague =
                        mainData?.popularLeagues[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedLeague = index;
                        });
                        Get.to(
                          () => ClubScreen(
                            footballLeagueId: popularLeague.id,
                            footballLeagueLogo: popularLeague.logoWhite,
                            footballLeagueName: popularLeague.name,
                            footballClubTotal: popularLeague.clubTotal,
                          ),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 2,
                              color:
                                  selectedLeague == index
                                      ? adjustColor(primaryColor)
                                      : adjustColor(thirdColor),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(18),
                          color: adjustColor(secondaryColor),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          width: 10,
                          child: Image.network(popularLeague.logoWhite),
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      );
    }

    Widget buildPopularStadium() {
      return Container(
        padding: const EdgeInsets.only(top: 32, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Popular Stadium',
              style: boldTextStyle.copyWith(color: whiteColor, fontSize: 16),
            ),
            isLoading
                ? CardRowShimmer()
                : GridView.builder(
                  padding: EdgeInsets.only(top: 24),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                    mainAxisExtent: 70,
                  ),
                  itemCount: mainData?.popularClubs.length,
                  itemBuilder: (context, index) {
                    MainPopularClub? popularClub =
                        mainData?.popularClubs[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => StadiumScreen(
                            footballClubId: popularClub.footballClubId,
                            footballLeagueId: popularClub.footballLeagueId,
                            footballClubLogo: popularClub.logoWhite!,
                            footballClubName: popularClub.clubName,
                            footballStadiumName: popularClub.stadiumName!,
                          ),
                          transition: Transition.rightToLeft,
                        );
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Image.network(
                                    popularClub!.logoWhite!,
                                    width: 22,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      popularClub.clubName,
                                      style: semiBoldTextStyle.copyWith(
                                        color: whiteColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      popularClub.stadiumName!,
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
                              "Capacity: ${popularClub.capacity}",
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

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildCarousel(),
                buildPopularLeague(),
                buildPopularStadium(),
                buildBannerAds(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
