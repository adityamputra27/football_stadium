import 'dart:io';

import 'package:flutter/material.dart';
import 'package:football_stadium/data/services/notification_service.dart';
import 'package:football_stadium/presentation/screens/home_screen.dart';
import 'package:football_stadium/presentation/screens/setting_screen.dart';
import 'package:football_stadium/presentation/screens/league_screen.dart';
import 'package:football_stadium/presentation/widgets/navigation/bottom_navigation.dart';
import 'package:football_stadium/presentation/widgets/navigation/header_navigation.dart';
import 'package:football_stadium/utils/scroll_behaviour.dart';
import 'package:football_stadium/utils/theme.dart';

class MainScreen extends StatefulWidget {
  final int activeIndex;
  const MainScreen({super.key, this.activeIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int selectedIndex;

  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.activeIndex;

    notificationService.requestNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.isTokenRefresh();
    notificationService.getDeviceToken().then((value) {
      print(value);
    });
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
