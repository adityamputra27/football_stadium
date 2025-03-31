import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:football_stadium/presentation/widgets/shimmers/paragraph_shimmer.dart';
import 'package:football_stadium/utils/ad_helper.dart';
import 'package:football_stadium/utils/scroll_behaviour.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class StadiumScreen extends StatefulWidget {
  const StadiumScreen({super.key});

  @override
  State<StadiumScreen> createState() => _StadiumScreenState();
}

class _StadiumScreenState extends State<StadiumScreen> {
  late CarouselSliderController innerCarouselController;
  int innerSliderIndex = 0;
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
    innerCarouselController = CarouselSliderController();

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
    Widget buildTitle() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Allianz Arena Stadium',
            style: boldTextStyle.copyWith(color: whiteColor, fontSize: 18),
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

    Widget buildCarousel() {
      List<dynamic> carouselData = ["assets/images/stadiums/allianz_arena.png"];
      List<bool> isRenovations = [false];
      List clubs = [
        [
          "Bayern Munchen",
          "assets/images/logo/teams/bayern_munich.png",
          "Allianz Arena",
        ],
      ];

      return ListView(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: CarouselSlider.builder(
                    itemCount: carouselData.length,
                    carouselController: innerCarouselController,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                      int realIndex,
                    ) {
                      final data = carouselData[index];
                      return SizedBox(
                        child: Stack(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(data),
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
                                      Radius.circular(16),
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  isRenovations[index]
                                      ? Container(
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          bottom: 6,
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: Text(
                                          'Renovation'.toUpperCase(),
                                          style: boldTextStyle.copyWith(
                                            color: whiteColor,
                                            fontSize: 10,
                                          ),
                                        ),
                                      )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 2),
                                    child: Image.asset(
                                      clubs[index][1],
                                      width: 25,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        clubs[index][0],
                                        style: semiBoldTextStyle.copyWith(
                                          color: whiteColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        clubs[index][2],
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
                      height: 250,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.ease,
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
                  bottom: MediaQuery.of(context).size.height * .025,
                  right: MediaQuery.of(context).size.height * .015,
                  child: Row(
                    children: List.generate(carouselData.length, (index) {
                      bool isSelected = innerSliderIndex == index;
                      return GestureDetector(
                        onTap: () {},
                        child: AnimatedContainer(
                          width: 8,
                          height: 8,
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
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget buildInformation() {
      Widget buildTableRow(String title, String value) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width / 2.25,
                child: Text(
                  title,
                  style: regularTextStyle.copyWith(
                    color: whiteColor,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  ':',
                  style: regularTextStyle.copyWith(
                    color: whiteColor,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: mediumTextStyle.copyWith(
                    color: whiteColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Information',
                style: boldTextStyle.copyWith(color: whiteColor, fontSize: 18),
              ),
            ),
            buildTableRow('Capacity', '66 704 seats'),
            buildTableRow('Country', 'Germany'),
            buildTableRow('City', 'Berlin'),
            buildTableRow('Clubs', 'FC Bayern Munchen'),
            buildTableRow('Cost', '200 mln \$'),
          ],
        ),
      );
    }

    Widget buildHistory() {
      String text =
          "“It is the most remarkable arena I have ever seen. As a football ground it is unrivalled in the world. It is an honour to Manchester.” is what The  Sporting Chronicle wrote about Old Trafford upon opening in February of 1910. Quite a welcome, but the stadium proved worthy of its reputation over the years. \n\nBefore moving to Old Trafford, the great Man United began as Newton Heath and only earned its current name after the old club dissolved in early 20th century. By 1909, just 7 years into its operation as United, owner of local brewery and chairman of the club, John Henry Davies, pumped £90,000 into construction of a brand new stadium with open-air embankments on three sides and a covered main grandstand in the south.\n\n“It is the most remarkable arena I have ever seen. As a football ground it is unrivalled in the world. It is an honour to Manchester.” is what The  Sporting Chronicle wrote about Old Trafford upon opening in February of 1910. Quite a welcome, but the stadium proved worthy of its reputation over the years. \n\nBefore moving to Old Trafford, the great Man United began as Newton Heath and only earned its current name after the old club dissolved in early 20th century. By 1909, just 7 years into its operation as United, owner of local brewery and chairman of the club, John Henry Davies, pumped £90,000 into construction of a brand new stadium with open-air embankments on three sides and a covered main grandstand in the south.";
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'History',
                style: boldTextStyle.copyWith(color: whiteColor, fontSize: 18),
              ),
            ),
            Text(text, style: regularTextStyle.copyWith(color: whiteColor)),
          ],
        ),
      );
    }

    Widget buildHeader() {
      double paddingTop = 0;
      if (Platform.isAndroid) {
        paddingTop = 24;
      }
      return Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 24,
          top: paddingTop,
        ),
        color: backgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [buildButton(), buildTitle()],
        ),
      );
    }

    Widget buildBannerAds() {
      return (_bannerAd != null)
          ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 32, top: 0),
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          )
          : Container();
    }

    Widget buildContent() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCarousel(),
          buildInformation(),
          buildHistory(),
          buildBannerAds(),
        ],
      );
    }

    Widget buildLoadingContent() {
      final double fullSizeWidth = MediaQuery.of(context).size.width;
      final double marginTop16 = 16;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ParagraphShimmer(customWidth: fullSizeWidth, customHeight: 250),
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return ParagraphShimmer(
                customWidth: fullSizeWidth,
                customHeight: 20,
                customMarginTop: marginTop16,
              );
            },
          ),
          ParagraphShimmer(
            customWidth: 300,
            customHeight: 20,
            customMarginTop: marginTop16,
          ),
          ParagraphShimmer(
            customWidth: 300,
            customHeight: 20,
            customMarginTop: marginTop16,
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehaviour(),
          child: Column(
            children: [
              buildHeader(),
              Expanded(
                child: SingleChildScrollView(child: buildLoadingContent()),
              ),
              // Expanded(child: SingleChildScrollView(child: buildContent())),
            ],
          ),
        ),
      ),
    );
  }
}
