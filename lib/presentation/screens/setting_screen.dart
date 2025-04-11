import 'package:flutter/material.dart';
import 'package:football_stadium/data/services/notification_service.dart';
import 'package:football_stadium/presentation/widgets/shimmers/card_row_shimmer.dart';
import 'package:football_stadium/utils/ad_helper.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // final Map<String, bool> _notificationSettings = {
  //   'topic_football_stadium': true,
  //   'topic_football_league': true,
  //   'topic_football_player': true,
  //   'topic_football_club': true,
  //   'topic_football_match': true,
  //   'topic_football_news': true,
  //   'topic_football_event': true,
  // };

  NotificationService notificationService = NotificationService();

  BannerAd? bannerAd;

  void loadBannerAd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
  }

  Map<String, bool> _notificationSettings = {};
  bool isLoading = true;
  Future<void> _loadNotificationSettings() async {
    final prefs = await notificationService.loadPreferences();
    setState(() {
      _notificationSettings = prefs;
      isLoading = false;
    });
  }

  Future<void> _toggleNotificationSetting(String topic, bool value) async {
    setState(() {
      _notificationSettings[topic] = value;
    });

    await notificationService.toggleSubscription(topic, value);
    await notificationService.savePreferences(_notificationSettings);
  }

  @override
  void initState() {
    super.initState();
    loadBannerAd();
    _loadNotificationSettings();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTitle() {
      return Text(
        'Notification Settings',
        style: boldTextStyle.copyWith(color: whiteColor, fontSize: 16),
      );
    }

    Widget buildBannerAds() {
      return (bannerAd != null)
          ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 24, top: 16),
              width: bannerAd!.size.width.toDouble(),
              height: bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: bannerAd!),
            ),
          )
          : Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 24,
            bottom: 14,
          ),
          child: buildTitle(),
        ),
        (_notificationSettings.isEmpty && isLoading)
            ? Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 0,
                bottom: 14,
              ),
              child: CardRowShimmer(itemCount: 5, height: 60),
            )
            : Column(
              children:
                  _notificationTopics.map((notification) {
                    return SwitchListTile(
                      splashRadius: 0,
                      activeColor: whiteColor,
                      activeTrackColor: primaryColor,
                      value: _notificationSettings[notification]!,
                      title: Text(
                        _getNotificationTitle(notification),
                        style: regularTextStyle.copyWith(
                          color: subtitleColor,
                          fontSize: 14,
                        ),
                      ),
                      onChanged: (value) {
                        _toggleNotificationSetting(notification, value);
                      },
                    );
                  }).toList(),
            ),
        buildBannerAds(),
      ],
    );
  }

  List<String> get _notificationTopics => _notificationSettings.keys.toList();

  String _getNotificationTitle(String key) {
    return {
      'topic_football_stadium': 'Football Stadium',
      'topic_football_league': 'Football League',
      'topic_football_player': 'Football Player',
      'topic_football_club': 'Football Club',
      'topic_football_match': 'Football Match',
      'topic_football_news': 'Football News',
      'topic_football_event': 'Football Event',
    }[key]!;
  }
}
