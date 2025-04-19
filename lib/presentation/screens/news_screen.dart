import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:football_stadium/data/models/news_model.dart';
import 'package:football_stadium/presentation/screens/news_detail_screen.dart';
import 'package:football_stadium/presentation/widgets/shimmers/featured_news_shimmer.dart';
import 'package:football_stadium/presentation/widgets/shimmers/latest_news_shimmer.dart';
import 'package:football_stadium/utils/environment.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/get.dart';
import 'package:scrollable_tab_view/scrollable_tab_view.dart';
import 'package:http/http.dart' as http;

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<NewsModel> footballNewsFeaturedData = [];
  List<NewsModel> footballNewsRegulerData = [];

  bool isLoading = true;
  String newsCategory = 'Stadiums';

  @override
  void initState() {
    super.initState();
    fetchFootballNewsData();
  }

  Future<void> fetchFootballNewsData() async {
    final response = await http.get(
      Uri.parse(
        "${Environment.baseURL}/all-football-news?category=$newsCategory",
      ),
      headers: {'Football-Stadium-App': Environment.valueHeader},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body)['data']['data'];
      setState(() {
        footballNewsFeaturedData =
            (jsonData['featured_news'] as List)
                .map((data) => NewsModel.fromJson(data))
                .toList();

        footballNewsRegulerData =
            (jsonData['regular_news'] as List)
                .map((data) => NewsModel.fromJson(data))
                .toList();

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }
  }

  void showNewsByCategory(int tabIndex) {
    switch (tabIndex) {
      case 0:
        setState(() {
          newsCategory = 'Stadiums';
        });
        break;
      case 1:
        setState(() {
          newsCategory = 'Leagues';
        });
        break;
      case 2:
        setState(() {
          newsCategory = 'Clubs';
        });
        break;
      case 3:
        setState(() {
          newsCategory = 'Players';
        });
        break;
      case 4:
        setState(() {
          newsCategory = 'International';
        });
        break;
      default:
        setState(() {
          newsCategory = 'Stadiums';
        });
        break;
    }

    setState(() {
      isLoading = true;
    });
    fetchFootballNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 8),
      child: ScrollableTab(
        indicatorWeight: 1,
        indicatorColor: primaryColor,
        unselectedLabelColor: grayColor,
        unselectedLabelStyle: regularTextStyle.copyWith(fontSize: 12),
        labelStyle: semiBoldTextStyle.copyWith(fontSize: 12),
        padding: EdgeInsets.all(0),
        dividerColor: Colors.transparent,
        isScrollable: true,
        useMaxWidth: true,
        tabBarAlignment: TabAlignment.start,
        tabAlignment: Alignment.centerLeft,
        labelColor: whiteColor,
        onTap: (index) {
          showNewsByCategory(index);
        },
        tabs: [
          Tab(text: 'Stadiums'),
          Tab(text: 'Leagues'),
          Tab(text: 'Clubs'),
          Tab(text: 'Players'),
          Tab(text: 'International'),
        ],
        children: [
          _buildTabContent(),
          _buildTabContent(),
          _buildTabContent(),
          _buildTabContent(),
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 18,
              left: 15,
              right: 15,
              bottom: 15,
            ),
            child: Text(
              'Featured News',
              style: boldTextStyle.copyWith(color: whiteColor, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 180,
            child:
                isLoading
                    ? ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      children: [
                        FeaturedNewsShimmer(),
                        FeaturedNewsShimmer(),
                        FeaturedNewsShimmer(),
                      ],
                    )
                    : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: footballNewsFeaturedData.length,
                      itemBuilder: (context, index) {
                        final NewsModel footballNewsData =
                            footballNewsFeaturedData[index];
                        return _buildFeaturedNewsCard(footballNewsData);
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 24, bottom: 15),
            child: Text(
              'Latest News',
              style: boldTextStyle.copyWith(fontSize: 16, color: whiteColor),
            ),
          ),
          isLoading
              ? ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  LatestNewsShimmer(),
                  LatestNewsShimmer(),
                  LatestNewsShimmer(),
                  LatestNewsShimmer(),
                  LatestNewsShimmer(),
                ],
              )
              : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: footballNewsRegulerData.length,
                itemBuilder: (contex, index) {
                  final NewsModel footballNewsData =
                      footballNewsRegulerData[index];
                  return _buildRegularNewsCard(footballNewsData);
                },
              ),
        ],
      ),
    );
  }

  Widget _buildFeaturedNewsCard(NewsModel footballNewsData) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => NewsDetailScreen(footballNewsData: footballNewsData),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      width: 250,
                      fit: BoxFit.cover,
                      imageUrl: footballNewsData.image,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: primaryColor, width: 1.5),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [Colors.transparent, backgroundColor],
                          stops: [0.0, 0.85],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            footballNewsData.title,
                            style: semiBoldTextStyle.copyWith(
                              fontSize: 14,
                              color: whiteColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            footballNewsData.diff,
                            style: regularTextStyle.copyWith(
                              color: grayColor,
                              fontSize: 12,
                            ),
                          ),
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
    );
  }

  Widget _buildRegularNewsCard(NewsModel footballNewsData) {
    return GestureDetector(
      onTap: () {
        Get.to(
          NewsDetailScreen(footballNewsData: footballNewsData),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: footballNewsData.image,
                width: 120,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    footballNewsData.title,
                    style: semiBoldTextStyle.copyWith(color: whiteColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    footballNewsData.diff,
                    style: regularTextStyle.copyWith(
                      color: grayColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
