import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:football_stadium/data/models/football_stadium_model.dart';
import 'package:football_stadium/presentation/widgets/shimmers/paragraph_shimmer.dart';
import 'package:football_stadium/utils/ad_helper.dart';
import 'package:football_stadium/utils/environment.dart';
import 'package:football_stadium/utils/scroll_behaviour.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

class StadiumScreen extends StatefulWidget {
  final int footballLeagueId;
  final int footballClubId;
  final String footballClubName;
  final String footballClubLogo;
  final String footballStadiumName;
  const StadiumScreen({
    super.key,
    required this.footballLeagueId,
    required this.footballClubId,
    required this.footballClubName,
    required this.footballClubLogo,
    required this.footballStadiumName,
  });

  @override
  State<StadiumScreen> createState() => _StadiumScreenState();
}

class _StadiumScreenState extends State<StadiumScreen> {
  late CarouselSliderController innerCarouselController;
  int innerSliderIndex = 0;
  BannerAd? _bannerAd;
  bool isLoading = true;
  FootballStadiumModel? footballStadium;

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

  Future<void> fetchFootballStadiumDetail() async {
    final response = await http.get(
      Uri.parse(
        "${Environment.baseURL}/stadium/${widget.footballLeagueId}/league/${widget.footballClubId}/club",
      ),
      headers: {'Football-Stadium-App': Environment.valueHeader},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body)['data']['data'];

      setState(() {
        footballStadium = FootballStadiumModel.fromJson(jsonData);
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
    fetchFootballStadiumDetail();
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
            widget.footballStadiumName,
            style: boldTextStyle.copyWith(color: whiteColor, fontSize: 16),
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
                    itemCount: footballStadium?.footballStadiumFiles.length,
                    carouselController: innerCarouselController,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                      int realIndex,
                    ) {
                      final FootballStadiumFileModel? footballStadiumFile =
                          footballStadium?.footballStadiumFiles[index];
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
                                        footballStadiumFile!.filePath,
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
                            // Container(
                            //   padding: const EdgeInsets.only(
                            //     left: 16,
                            //     right: 12,
                            //     top: 10,
                            //   ),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.end,
                            //     children: [
                            //       isRenovations[index]
                            //           ? Container(
                            //             decoration: BoxDecoration(
                            //               color: primaryColor,
                            //               borderRadius: BorderRadius.all(
                            //                 Radius.circular(8),
                            //               ),
                            //             ),
                            //             padding: const EdgeInsets.only(
                            //               top: 4,
                            //               bottom: 6,
                            //               right: 8,
                            //               left: 8,
                            //             ),
                            //             child: Text(
                            //               'Renovation'.toUpperCase(),
                            //               style: boldTextStyle.copyWith(
                            //                 color: whiteColor,
                            //                 fontSize: 10,
                            //               ),
                            //             ),
                            //           )
                            //           : const SizedBox(),
                            //     ],
                            //   ),
                            // ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 2),
                                    child: Image.network(
                                      widget.footballClubLogo,
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
                                        widget.footballClubName,
                                        style: semiBoldTextStyle.copyWith(
                                          color: whiteColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        widget.footballStadiumName,
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
                  bottom: MediaQuery.of(context).size.height * .025,
                  right: MediaQuery.of(context).size.height * .015,
                  child: Row(
                    children: List.generate(
                      footballStadium!.footballStadiumFiles.length,
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
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  ':',
                  style: regularTextStyle.copyWith(
                    color: whiteColor,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: mediumTextStyle.copyWith(
                    color: whiteColor,
                    fontSize: 12,
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
                style: boldTextStyle.copyWith(color: whiteColor, fontSize: 15),
              ),
            ),
            buildTableRow('Capacity', footballStadium!.capacity),
            buildTableRow('Country', footballStadium!.country),
            buildTableRow('City', footballStadium!.city),
            buildTableRow('Club', widget.footballClubName),
            buildTableRow('Cost', '${footballStadium!.cost} \$'),
          ],
        ),
      );
    }

    Widget buildHistory() {
      String text = footballStadium!.description;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 16, left: 8),
              child: Text(
                'History',
                style: boldTextStyle.copyWith(color: whiteColor, fontSize: 15),
              ),
            ),
            Html(
              data: text,
              style: {
                "*": Style(
                  color: whiteColor,
                  fontFamily: fontFamily,
                  fontSize: FontSize(13),
                ),
              },
            ),
          ],
        ),
      );
    }

    Widget buildHeader() {
      double paddingTop = 0;
      if (Platform.isAndroid) {
        paddingTop = 18;
      }
      return Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 18,
          top: paddingTop,
        ),
        color: adjustColor(backgroundColor),
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
      backgroundColor: adjustColor(backgroundColor),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehaviour(),
          child: Column(
            children: [
              buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: isLoading ? buildLoadingContent() : buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
