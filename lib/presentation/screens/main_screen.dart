import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:football_stadium/data/services/notification_service.dart';
import 'package:football_stadium/presentation/screens/home_screen.dart';
import 'package:football_stadium/presentation/screens/setting_screen.dart';
import 'package:football_stadium/presentation/screens/league_screen.dart';
import 'package:football_stadium/presentation/widgets/navigation/bottom_navigation.dart';
import 'package:football_stadium/presentation/widgets/navigation/header_navigation.dart';
import 'package:football_stadium/utils/environment.dart';
import 'package:football_stadium/utils/scroll_behaviour.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  final int activeIndex;
  const MainScreen({super.key, this.activeIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int selectedIndex;

  NotificationService notificationService = NotificationService();

  Future<bool> sendFirstNotification() async {
    final prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt('user_id')!;
    String firebaseCloudMessagingToken =
        await notificationService.getDeviceToken();

    final response = await http.post(
      Uri.parse("${Environment.baseURL}/first-notification-device"),
      headers: <String, String>{
        'Football-Stadium-App': Environment.valueHeader,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'fcm_token': firebaseCloudMessagingToken,
      }),
    );

    var responseData = jsonDecode(response.body);
    prefs.setBool('is_new_device', responseData['data']['is_new_device']);

    return responseData['data']['status'];
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.activeIndex;

    notificationService.requestNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.isTokenRefresh();
    notificationService.getDeviceToken().then((value) {
      if (kDebugMode) {
        print(value);
      }
    });

    sendFirstNotification();
  }

  void _onItemTapped(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List screens = [HomeScreen(), LeagueScreen(), SettingScreen()];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehaviour(),
          child: Column(
            children: [
              HeaderNavigation(),
              Expanded(child: screens[selectedIndex]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
