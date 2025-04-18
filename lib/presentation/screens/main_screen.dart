import 'dart:convert';

import 'package:app_install_events/app_install_events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:football_stadium/data/database/notification_database.dart';
import 'package:football_stadium/data/services/notification_service.dart';
import 'package:football_stadium/presentation/screens/about_screen.dart';
import 'package:football_stadium/presentation/screens/home_screen.dart';
import 'package:football_stadium/presentation/screens/news_screen.dart';
import 'package:football_stadium/presentation/screens/setting_screen.dart';
import 'package:football_stadium/presentation/screens/league_screen.dart';
import 'package:football_stadium/presentation/widgets/navigation/bottom_navigation.dart';
import 'package:football_stadium/presentation/widgets/navigation/header_navigation.dart';
import 'package:football_stadium/utils/environment.dart';
import 'package:football_stadium/utils/scroll_behaviour.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class MainScreen extends StatefulWidget {
  final int activeIndex;
  const MainScreen({super.key, this.activeIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int selectedIndex;

  NotificationService notificationService = NotificationService();

  void detectUninstalledApp() async {
    AppIUEvents appInstallEvents = AppIUEvents();
    appInstallEvents.startListening();
    appInstallEvents.appEvents.listen((event) {
      if (event.type == IUEventType.uninstalled) {
        resetUser().then((value) {
          if (value == 1) {
            if (kDebugMode) {
              print('Uninstalled and reset user');
            }
          } else {
            if (kDebugMode) {
              print('Error resetting user');
            }
          }
        });
      } else if (event.type == IUEventType.installed) {
        if (kDebugMode) {
          print('Installed');
        }
      }
    });
  }

  Future<int> resetUser() async {
    final prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt('user_id')!;
    String firebaseCloudMessagingToken =
        await notificationService.getDeviceToken();

    final response = await http.post(
      Uri.parse("${Environment.baseURL}/reset-user"),
      headers: <String, String>{
        'Football-Stadium-App': Environment.valueHeader,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'fcm_token': firebaseCloudMessagingToken,
      }),
    );

    dynamic responseData = jsonDecode(response.body);
    bool isSuccess = responseData['data']['status'];

    if (isSuccess) {
      prefs.setInt('user_id', 0);
      prefs.setBool('is_new_device', false);
      prefs.remove('user_id');
      prefs.remove('is_new_device');
    } else {
      if (kDebugMode) {
        print('Error : ${response.statusCode}');
      }
    }

    return isSuccess ? 1 : 0;
  }

  // void resetUserData() async {
  //   final dbPath = await getDatabasesPath();
  //   final path = join(dbPath, 'notifications.db');
  //   await deleteDatabase(path);

  //   NotificationDatabase.instance.deleteAllNotifications();
  //   SharedPreferences.getInstance().then((prefs) {
  //     prefs.setInt('counter_notification', 0);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.activeIndex;

    notificationService.requestNotificationPermission((isGranted) {
      if (kDebugMode) {
        print(isGranted);
      }
    });
    // notificationService.firebaseInit(context);
    // notificationService.isTokenRefresh();
    // notificationService.getDeviceToken().then((value) {
    //   if (kDebugMode) {
    //     print(value);
    //   }
    // });

    // resetUserData();
    // detectUninstalledApp();
  }

  void _onItemTapped(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List screens = [
      HomeScreen(),
      LeagueScreen(),
      NewsScreen(),
      SettingScreen(),
      AboutScreen(),
    ];

    return Scaffold(
      backgroundColor: adjustColor(backgroundColor),
      body: ScrollConfiguration(
        behavior: CustomScrollBehaviour(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HeaderNavigation(),
            Expanded(child: screens[selectedIndex]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
