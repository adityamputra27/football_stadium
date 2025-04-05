import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:football_stadium/data/models/notification_model.dart';
import 'package:football_stadium/presentation/widgets/shimmers/card_row_shimmer.dart';
import 'package:football_stadium/utils/ad_helper.dart';
import 'package:football_stadium/utils/environment.dart';
import 'package:football_stadium/utils/scroll_behaviour.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  final Function(int id) onMarkRead;

  const NotificationScreen({super.key, required this.onMarkRead});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = true;
  List<NotificationModel> notifications = [];
  List<int> markedNotifications = [];
  BannerAd? _bannerAd;

  Future<void> fetchNotifications() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final userId = sharedPreferences.getInt('user_id');

      final response = await http.get(
        Uri.parse("${Environment.baseURL}/notification-list/$userId/user"),
        headers: {
          'Accept-Type': 'application/json',
          'Football-Stadium-App': Environment.valueHeader,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        final List<dynamic> notificationsJson = jsonData['data'];

        setState(() {
          notifications =
              notificationsJson
                  .map(
                    (notification) => NotificationModel.fromJson(notification),
                  )
                  .toList();

          isLoading = false;
        });
      } else {
        if (kDebugMode) {
          print('Error : ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error : $e');
      }
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

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  void initState() {
    super.initState();
    _initGoogleMobileAds();
    _loadBannerAd();

    fetchNotifications();
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
            'Notifications',
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

    Widget buildNotifications() {
      return Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 24, top: 0),
              child: Text(
                'All notifications',
                style: mediumTextStyle.copyWith(color: whiteColor),
              ),
            ),

            isLoading
                ? CardRowShimmer(itemCount: 7)
                : notifications.isEmpty
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'No data',
                          style: mediumTextStyle.copyWith(
                            fontSize: 12,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final NotificationModel notification = notifications[index];
                    return GestureDetector(
                      onTap: () {
                        widget.onMarkRead(notification.id);
                        setState(() {
                          markedNotifications.add(notification.id);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border(
                            top: BorderSide(color: thirdColor, width: 1.5),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.info,
                            color: whiteColor,
                            size: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          contentPadding: EdgeInsets.only(
                            top: 4,
                            bottom: 6,
                            left: 16,
                            right: 16,
                          ),
                          tileColor:
                              markedNotifications.contains(notification.id)
                                  ? adjustColor(secondaryColor)
                                  : adjustColor(thirdColor),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              notification.title,
                              style: semiBoldTextStyle.copyWith(
                                fontSize: 14,
                                color: whiteColor,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            notification.description,
                            style: mediumTextStyle.copyWith(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                        ),
                      ),
                    );
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
              margin: const EdgeInsets.only(bottom: 10, top: 32),
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          )
          : Container();
    }

    Widget buildContent() {
      return Column(children: [buildNotifications(), buildBannerAds()]);
    }

    return Scaffold(
      backgroundColor: adjustColor(backgroundColor),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehaviour(),
          child: Column(
            children: [
              buildHeader(),
              Expanded(child: SingleChildScrollView(child: buildContent())),
            ],
          ),
        ),
      ),
    );
  }
}
