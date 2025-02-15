import 'package:flutter/material.dart';
import 'package:football_stadium/presentation/screens/home_screen.dart';
import 'package:football_stadium/presentation/screens/setting_screen.dart';
import 'package:football_stadium/presentation/screens/stadium_screen.dart';
import 'package:football_stadium/utils/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List screens = [HomeScreen(), StadiumScreen(), SettingScreen()];

    Widget buildHeaderNavigation() {
      return SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          print('NOTIFICATION CLICKED!');
                        },
                        icon: Icon(
                          Icons.notifications,
                          size: 28,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 24),
                width: double.infinity,
                height: 1,
                decoration: BoxDecoration(color: borderColor),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildBottomNavigation() {
      return Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 30,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            elevation: 0,
            selectedLabelStyle: semiBoldTextStyle,
            unselectedLabelStyle: mediumTextStyle,
            unselectedIconTheme: IconThemeData(color: grayColor),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: whiteColor,
            unselectedItemColor: grayColor,
            backgroundColor: secondaryColor,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.only(top: 12, bottom: 4),
                  child: Icon(Icons.home_filled, size: 24),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.only(top: 12, bottom: 4),
                  child: Icon(Icons.stadium_rounded),
                ),
                label: 'Stadium',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.only(top: 12, bottom: 4),
                  child: Icon(Icons.settings),
                ),
                label: 'Setting',
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          buildHeaderNavigation(),
          Expanded(child: screens[selectedIndex]),
        ],
      ),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }
}
