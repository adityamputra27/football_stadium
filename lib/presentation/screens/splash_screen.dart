import 'dart:async';

import 'package:flutter/material.dart';
import 'package:football_stadium/data/services/notification_service.dart';
import 'package:football_stadium/presentation/screens/main_screen.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/route_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;
  NotificationService notificationService = NotificationService();

  String appVersion = '';
  String appBuildNumber = '';

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
      appBuildNumber = packageInfo.buildNumber;
    });
  }

  Future<void> requestPermission() async {
    NotificationService().requestNotificationPermission((isGranted) {
      redirectToMainScreen();
    });
    NotificationService().firebaseInit(context);
    NotificationService().isTokenRefresh();
  }

  void redirectToMainScreen() {
    Get.offAll(
      () => const MainScreen(activeIndex: 0),
      transition: Transition.rightToLeft,
    );
  }

  @override
  void initState() {
    super.initState();
    getPackageInfo();
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: adjustColor(backgroundColor),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/new-stadium-logo.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Football Stadium',
                            style: boldTextStyle.copyWith(
                              color: whiteColor,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'in the World',
                            style: semiBoldTextStyle.copyWith(
                              fontSize: 16,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  isLoading
                      ? Container(
                        padding: EdgeInsets.only(top: 32),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: primaryColor,
                            strokeWidth: 4,
                          ),
                        ),
                      )
                      : SizedBox(),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'v${appVersion.toString()} (${appBuildNumber.toString()})',
                    style: mediumTextStyle.copyWith(color: whiteColor),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
