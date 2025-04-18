import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:football_stadium/data/database/notification_database.dart';
import 'package:football_stadium/data/services/notification_service.dart';
import 'package:football_stadium/presentation/screens/notification_screen.dart';
import 'package:football_stadium/utils/notification_counter.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderNavigation extends StatefulWidget {
  const HeaderNavigation({super.key});

  @override
  State<HeaderNavigation> createState() => _HeaderNavigationState();
}

class _HeaderNavigationState extends State<HeaderNavigation> {
  int firebaseNotificationCount = 0;

  int get totalUnreadNotification => firebaseNotificationCount;

  Future<void> markNotificationAsRead(String id) async {
    try {
      NotificationDatabase.instance.markNotificationAsRead(id);

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      int currentCount = sharedPreferences.getInt('counter_notification') ?? 0;
      if (currentCount > 0) {
        await sharedPreferences.setInt(
          'counter_notification',
          currentCount - 1,
        );
        setState(() {
          firebaseNotificationCount = currentCount - 1;
        });
      }

      // setState(() {
      //   unreadNotificationCount--;
      // });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Notification mark as read success',
            style: regularTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      );
      // SharedPreferences sharedPreferences =
      //     await SharedPreferences.getInstance();
      // final userId = sharedPreferences.getInt('user_id');

      // final response = await http.post(
      //   Uri.parse("${Environment.baseURL}/notification-list/$userId/mark/$id"),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Football-Stadium-App': Environment.valueHeader,
      //   },
      // );

      // if (response.statusCode == 200) {
      //   final jsonData = jsonDecode(response.body)['data'];
      //   final int remainingUnreadNotificationCount =
      //       jsonData['data']['remaining_unread_notification_count'];

      //   setState(() {
      //     firebaseNotificationCount = 0;
      //     unreadNotificationCount = remainingUnreadNotificationCount;
      //   });

      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text(
      //         'Notification mark as read success',
      //         style: regularTextStyle,
      //         textAlign: TextAlign.center,
      //       ),
      //     ),
      //   );
      // } else {
      //   if (kDebugMode) {
      //     print('Error : ${response.statusCode}');
      //   }
      // }
    } catch (e) {
      if (kDebugMode) {
        print('Error : $e');
      }
    }
  }

  NotificationService notificationService = NotificationService();

  // Future<void> _initializeNotificationCounter() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  //   setState(() {
  //     firebaseNotificationCount =
  //         sharedPreferences.getInt('counter_notification') ?? 0;
  //   });
  // }

  void countNotificationFromFirebase() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      int currentCount = sharedPreferences.getInt('counter_notification') ?? 0;

      setState(() {
        firebaseNotificationCount = currentCount;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // _initializeNotificationCounter();
    // countNotificationFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = 0;

    if (Platform.isAndroid) {
      paddingTop = 16;
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
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'in the World',
                      style: semiBoldTextStyle.copyWith(
                        fontSize: 14,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.to(
                              () => NotificationScreen(
                                onMarkRead: markNotificationAsRead,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          },
                          icon: Icon(
                            Icons.notifications,
                            size: 24,
                            color: whiteColor,
                          ),
                        ),
                        StreamBuilder<int>(
                          stream: NotificationCounter().stream,
                          builder: (context, snapshot) {
                            final count = snapshot.data ?? 0;

                            return count > 0
                                ? Positioned(
                                  right: 6,
                                  top: 3,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      count.toString(),
                                      style: boldTextStyle.copyWith(
                                        fontSize: 10,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                )
                                : const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              width: double.infinity,
              height: 1,
              decoration: BoxDecoration(color: adjustColor(thirdColor)),
            ),
          ],
        ),
      ),
    );
  }
}
