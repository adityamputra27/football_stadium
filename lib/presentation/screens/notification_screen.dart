import 'dart:io';

import 'package:flutter/material.dart';
import 'package:football_stadium/presentation/screens/stadium_screen.dart';
import 'package:football_stadium/utils/scroll_behaviour.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
      List<String> descriptionsData = [
        "English Premier League - Etihad Stadium has been added to our app, let's check it out!",
        "English Premier League - Anfield Stadium has been updated, let's check it out!",
        "Hi! Thanks for installing our app, we hope you enjoy and let's check it out all of about our stadium information!",
        "Hi! Thanks for installing our app, we hope you enjoy and let's check it out all of about our stadium information!",
        "Hi! Thanks for installing our app, we hope you enjoy and let's check it out all of about our stadium information!",
        "Hi! Thanks for installing our app, we hope you enjoy and let's check it out all of about our stadium information!",
        "Hi! Thanks for installing our app, we hope you enjoy and let's check it out all of about our stadium information!",
        "Hi! Thanks for installing our app, we hope you enjoy and let's check it out all of about our stadium information!",
      ];
      List<String> notificationsData = [
        "[NEW] Stadium has been available!",
        "[UPDATE] Stadium has been update!",
        "Welcome to Football Stadium App!",
        "Welcome to Football Stadium App!",
        "Welcome to Football Stadium App!",
        "Welcome to Football Stadium App!",
        "Welcome to Football Stadium App!",
        "Welcome to Football Stadium App!",
      ];

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
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: notificationsData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => const StadiumScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        Icons.info,
                        color: index <= 3 ? subtitleColor : whiteColor,
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
                      tileColor: secondaryColor,
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          notificationsData[index],
                          style: semiBoldTextStyle.copyWith(
                            fontSize: 16,
                            color: index <= 3 ? subtitleColor : whiteColor,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        descriptionsData[index],
                        style: mediumTextStyle.copyWith(
                          fontSize: 14,
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
        paddingTop = 62;
      }

      return Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 24,
          top: paddingTop,
        ),
        color: backgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [buildButton(), buildTitle()],
        ),
      );
    }

    Widget buildContent() {
      return Column(children: [buildNotifications()]);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
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
