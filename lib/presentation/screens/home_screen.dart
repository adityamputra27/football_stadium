import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:football_stadium/utils/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CarouselSliderController innerCarouselController;
  int selectedLeague = 0;

  @override
  void initState() {
    super.initState();
    innerCarouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildCarousel() {
      return ListView(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .25,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: CarouselSlider(
                    carouselController: innerCarouselController,
                    items: [
                      SizedBox(
                        child: Stack(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        "assets/images/stadiums/signal_iduna_park.jpg",
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    gradient: LinearGradient(
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        initialGradientColor,
                                      ],
                                      stops: [0.0, 0.9],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 12,
                                top: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Capacity : 85.000',
                                    style: mediumTextStyle.copyWith(
                                      fontSize: 12,
                                      color: whiteColor,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      bottom: 6,
                                      right: 8,
                                      left: 8,
                                    ),
                                    child: Text(
                                      'Renovation'.toUpperCase(),
                                      style: boldTextStyle.copyWith(
                                        color: whiteColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 2),
                                    child: Image.asset(
                                      'assets/images/logo/teams/borussia_dortmund.png',
                                      width: 25,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Borussia Dortmund',
                                        style: semiBoldTextStyle.copyWith(
                                          color: whiteColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Signal Iduna Park',
                                        style: mediumTextStyle.copyWith(
                                          color: whiteColor,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Stack(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        "assets/images/stadiums/allianz_arena.png",
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    gradient: LinearGradient(
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        initialGradientColor,
                                      ],
                                      stops: [0.0, 0.9],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 12,
                                top: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Capacity : 70.000',
                                    style: mediumTextStyle.copyWith(
                                      fontSize: 12,
                                      color: whiteColor,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      bottom: 6,
                                      right: 8,
                                      left: 8,
                                    ),
                                    child: Text(
                                      'Renovation'.toUpperCase(),
                                      style: boldTextStyle.copyWith(
                                        color: whiteColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 2),
                                    child: Image.asset(
                                      'assets/images/logo/teams/bayern_munich.png',
                                      width: 25,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bayern Munchen',
                                        style: semiBoldTextStyle.copyWith(
                                          color: whiteColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Allianz Arena',
                                        style: mediumTextStyle.copyWith(
                                          color: whiteColor,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    options: CarouselOptions(
                      height: 180,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.ease,
                      enableInfiniteScroll: true,
                      viewportFraction: 1,
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * .05,
                  right: MediaQuery.of(context).size.height * .015,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: AnimatedContainer(
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: dotIndicatorActiveColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          duration: const Duration(milliseconds: 300),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: AnimatedContainer(
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: dotIndicatorDefaultColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          duration: const Duration(milliseconds: 300),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: AnimatedContainer(
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: dotIndicatorDefaultColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          duration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget buildPopularLeague() {
      List<String> leagueLogos = [
        "assets/images/logo/leagues/epl.png",
        "assets/images/logo/leagues/laliga.png",
        "assets/images/logo/leagues/serie_a.png",
        "assets/images/logo/leagues/briliga1.png",
      ];

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Popular League',
              style: boldTextStyle.copyWith(color: whiteColor, fontSize: 18),
            ),
            GridView.builder(
              padding: EdgeInsets.only(top: 24),
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
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 2,
                          color:
                              selectedLeague == index
                                  ? primaryColor
                                  : thirdColor,
                        ),
                        bottom: BorderSide(
                          width: 2,
                          color:
                              selectedLeague == index
                                  ? primaryColor
                                  : thirdColor,
                        ),
                        left: BorderSide(
                          width: 2,
                          color:
                              selectedLeague == index
                                  ? primaryColor
                                  : thirdColor,
                        ),
                        right: BorderSide(
                          width: 2,
                          color:
                              selectedLeague == index
                                  ? primaryColor
                                  : thirdColor,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(24),
                      color: secondaryColor,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 18,
                      ),
                      width: 10,
                      child: Image.asset(leagueLogos[index]),
                    ),
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    print('see all');
                  },
                  child: Text(
                    'See All',
                    style: mediumTextStyle.copyWith(
                      fontSize: 12,
                      color: whiteColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildPopularStadium() {
      List<String> stadiumLogos = [
        "assets/images/logo/teams/bayern_munich.png",
        "assets/images/logo/teams/manchester_united.png",
        "assets/images/logo/teams/borussia_dortmund.png",
      ];
      List<String> stadiumNames = [
        "Allianz Arena",
        "Old Trafford",
        "Signal Iduna Park",
      ];
      List<String> stadiumCapacities = ["70.000", "74.310", "81.365"];
      List<String> stadiumClubs = [
        "Bayern Munchen",
        "Manchester United",
        "Borussia Dortmund",
      ];

      return Container(
        padding: const EdgeInsets.only(top: 16, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Popular Stadium',
              style: boldTextStyle.copyWith(color: whiteColor, fontSize: 18),
            ),
            GridView.builder(
              padding: EdgeInsets.only(top: 24),
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
                    print(index);
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

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildCarousel(),
                buildPopularLeague(),
                buildPopularStadium(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
