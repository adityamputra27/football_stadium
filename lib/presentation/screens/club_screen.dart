import 'package:flutter/material.dart';
import 'package:football_stadium/presentation/screens/stadium_screen.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/get.dart';

class ClubScreen extends StatefulWidget {
  const ClubScreen({super.key});

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  @override
  Widget build(BuildContext context) {
    Widget buildTitle() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'English Premier League',
            style: boldTextStyle.copyWith(color: whiteColor, fontSize: 18),
          ),
          const SizedBox(height: 2),
          Text(
            'Stadium Totals : 20',
            style: mediumTextStyle.copyWith(color: whiteColor, fontSize: 12),
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

    Widget buildLogo() {
      return Container(
        padding: const EdgeInsets.only(right: 12, left: 4),
        child: Image.asset("assets/images/logo/leagues/epl.png", width: 25),
      );
    }

    Widget buildStadiums() {
      List<String> stadiumLogos = [
        "assets/images/logo/teams/manchester_united.png",
        "assets/images/logo/teams/manchester_city.png",
        "assets/images/logo/teams/chelsea.png",
      ];
      List<String> stadiumNames = [
        "Old Trafford",
        "Etihad Stadium",
        "Stamford Bridge",
      ];
      List<String> stadiumCapacities = ["70.000", "74.310", "81.365"];
      List<String> stadiumClubs = [
        "Manchester United",
        "Manchester City",
        "Chelsea F.C",
      ];

      return Container(
        padding: const EdgeInsets.only(top: 16, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 24, bottom: 24),
              child: Text(
                'Select club to see details',
                style: mediumTextStyle.copyWith(color: whiteColor),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                mainAxisExtent: 100,
              ),
              itemCount: stadiumLogos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print('test');
                    Get.to(
                      () => StadiumScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: secondaryColor,
                    ),
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 12),
                              child: Image.asset(
                                stadiumLogos[index],
                                width: 40,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  stadiumClubs[index],
                                  style: semiBoldTextStyle.copyWith(
                                    color: whiteColor,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  stadiumNames[index],
                                  style: mediumTextStyle.copyWith(
                                    color: whiteColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          "Capacity: ${stadiumCapacities[index]}",
                          style: mediumTextStyle.copyWith(
                            color: whiteColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    Widget buildContent() {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buildButton(), buildLogo(), buildTitle()],
            ),
          ),
          buildStadiums(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(child: buildContent())),
          ],
        ),
      ),
    );
  }
}
