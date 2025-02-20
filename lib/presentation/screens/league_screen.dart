import 'package:flutter/material.dart';
import 'package:football_stadium/presentation/screens/club_screen.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/get.dart';

class LeagueScreen extends StatefulWidget {
  const LeagueScreen({super.key});

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> {
  int selectedLeague = 0;

  @override
  Widget build(BuildContext context) {
    List<String> leagueLogos = [
      "assets/images/logo/leagues/epl.png",
      "assets/images/logo/leagues/laliga.png",
      "assets/images/logo/leagues/serie_a.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/epl.png",
      "assets/images/logo/leagues/laliga.png",
      "assets/images/logo/leagues/serie_a.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/epl.png",
      "assets/images/logo/leagues/laliga.png",
      "assets/images/logo/leagues/serie_a.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/epl.png",
      "assets/images/logo/leagues/laliga.png",
      "assets/images/logo/leagues/serie_a.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/briliga1.png",
      "assets/images/logo/leagues/briliga1.png",
    ];

    Widget buildListLeagues() {
      return GridView.builder(
        padding: EdgeInsets.only(top: 24, bottom: 32),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
          mainAxisExtent: 100,
        ),
        itemCount: leagueLogos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedLeague = index;
              });

              Get.to(() => ClubScreen(), transition: Transition.rightToLeft);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 2,
                    color: selectedLeague == index ? primaryColor : thirdColor,
                  ),
                  bottom: BorderSide(
                    width: 2,
                    color: selectedLeague == index ? primaryColor : thirdColor,
                  ),
                  left: BorderSide(
                    width: 2,
                    color: selectedLeague == index ? primaryColor : thirdColor,
                  ),
                  right: BorderSide(
                    width: 2,
                    color: selectedLeague == index ? primaryColor : thirdColor,
                  ),
                ),
                borderRadius: BorderRadius.circular(24),
                color: secondaryColor,
              ),
              padding: EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 20,
                ),
                width: 10,
                child: Image.asset(leagueLogos[index]),
              ),
            ),
          );
        },
      );
    }

    Widget buildTitle() {
      return Text(
        'Select League',
        style: boldTextStyle.copyWith(color: whiteColor, fontSize: 18),
      );
    }

    Widget buildContent() {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [buildTitle(), buildListLeagues()],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [Expanded(child: SingleChildScrollView(child: buildContent()))],
    );
  }
}
