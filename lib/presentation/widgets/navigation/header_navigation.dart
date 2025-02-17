import 'package:flutter/material.dart';
import 'package:football_stadium/utils/theme.dart';

class HeaderNavigation extends StatefulWidget {
  const HeaderNavigation({super.key});

  @override
  State<HeaderNavigation> createState() => _HeaderNavigationState();
}

class _HeaderNavigationState extends State<HeaderNavigation> {
  @override
  Widget build(BuildContext context) {
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
}
