import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:football_stadium/data/services/notification_service.dart';
import 'package:football_stadium/presentation/screens/main_screen.dart';
import 'package:football_stadium/utils/environment.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> registerDevice() async {
    notificationService.requestNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.isTokenRefresh();

    String deviceId = '-';
    String firebaseCloudMessagingToken =
        await notificationService.getDeviceToken();

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      deviceId = androidDeviceInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      deviceId = iosDeviceInfo.localizedModel;
    }

    final response = await http.post(
      Uri.parse("${Environment.baseURL}/register-device"),
      headers: <String, String>{
        'Football-Stadium-App': Environment.valueHeader,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'device_id': deviceId,
        'fcm_token': firebaseCloudMessagingToken,
      }),
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseData = jsonDecode(response.body);
    bool responseStatus = responseData['data']['status'];
    int responseUserId = responseData['data']['data']['id'];

    if (responseStatus) {
      prefs.setInt('user_id', responseUserId);
    } else {
      prefs.setInt('user_id', 0);
    }

    Timer(const Duration(seconds: 2), () {
      Get.offAll(
        () => const MainScreen(activeIndex: 0),
        transition: Transition.rightToLeft,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getPackageInfo();
    registerDevice();
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
