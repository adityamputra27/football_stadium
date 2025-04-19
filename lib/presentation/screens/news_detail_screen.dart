import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:football_stadium/data/models/football_stadium_model.dart';
import 'package:football_stadium/data/models/news_model.dart';
import 'package:football_stadium/presentation/widgets/shimmers/paragraph_shimmer.dart';
import 'package:football_stadium/utils/ad_helper.dart';
import 'package:football_stadium/utils/scroll_behaviour.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsModel footballNewsData;
  const NewsDetailScreen({super.key, required this.footballNewsData});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
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

  @override
  void initState() {
    super.initState();
    innerCarouselController = CarouselSliderController();

    _initGoogleMobileAds();
    _loadBannerAd();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTitle() {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: SizedBox(
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
                                    widget.footballNewsData.image,
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
                                  colors: [Colors.transparent, backgroundColor],
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
                              widget.footballNewsData.isFeaturedNews == 1
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
                                      'Featured News',
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget buildBody() {
      String text = widget.footballNewsData.body;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
              child: Text(
                widget.footballNewsData.title,
                style: boldTextStyle.copyWith(color: whiteColor, fontSize: 15),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
              child: Text(
                widget.footballNewsData.diff,
                style: mediumTextStyle.copyWith(color: grayColor, fontSize: 12),
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
        children: [buildCarousel(), buildBody(), buildBannerAds()],
      );
    }

    Widget buildLoadingContent() {
      final double fullSizeWidth = MediaQuery.of(context).size.width;
      final double marginTop16 = 16;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ParagraphShimmer(customWidth: fullSizeWidth, customHeight: 200),
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
