import 'dart:io';

import 'package:flutter/material.dart';
import 'package:football_stadium/presentation/screens/notification_screen.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/route_manager.dart';

class HeaderNavigation extends StatefulWidget {
  const HeaderNavigation({super.key});

  @override
  State<HeaderNavigation> createState() => _HeaderNavigationState();
}

class _HeaderNavigationState extends State<HeaderNavigation> {
  @override
  Widget build(BuildContext context) {
    double paddingTop = 0;

    if (Platform.isAndroid) {
      paddingTop = 24;
    }

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: paddingTop),
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
                        Get.to(
                          () => NotificationScreen(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      icon: Icon(
                        Icons.notifications,
                        size: 24,
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
              decoration: BoxDecoration(color: thirdColor),
            ),
          ],
        ),
      ),
    );
  }
}
