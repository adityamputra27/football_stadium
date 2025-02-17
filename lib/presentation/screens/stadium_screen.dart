import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:football_stadium/presentation/screens/club_screen.dart';
import 'package:football_stadium/presentation/screens/main_screen.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/get.dart';

class StadiumScreen extends StatefulWidget {
  const StadiumScreen({super.key});

  @override
  State<StadiumScreen> createState() => _StadiumScreenState();
}

class _StadiumScreenState extends State<StadiumScreen> {
  late CarouselSliderController innerCarouselController;

  @override
  void initState() {
    super.initState();
    innerCarouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTitle() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Allianz Arena Stadium',
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
          Get.to(() => ClubScreen(), transition: Transition.leftToRight);
        },
        child: Icon(Icons.arrow_back_ios, color: whiteColor, size: 20),
      );
    }

    Widget buildCarousel() {
      return ListView(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 24),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          SizedBox(
            height: 250,
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
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
                                        'Home of Bayern Munchen',
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
                      height: 250,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      viewportFraction: 1,
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * .025,
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

    Widget buildInformation() {
      Widget buildTableRow(String title, String value) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width / 2.25,
                child: Text(
                  title,
                  style: regularTextStyle.copyWith(
                    color: whiteColor,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  ':',
                  style: regularTextStyle.copyWith(
                    color: whiteColor,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: mediumTextStyle.copyWith(
                    color: whiteColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Information',
                style: boldTextStyle.copyWith(color: whiteColor, fontSize: 18),
              ),
            ),
            buildTableRow('Capacity', '66 704 seats'),
            buildTableRow('Country', 'Germany'),
            buildTableRow('City', 'Berlin'),
            buildTableRow('Clubs', 'FC Bayern Munchen'),
            buildTableRow('Cost', '200 mln \$'),
          ],
        ),
      );
    }

    Widget buildHistory() {
      String text =
          "“It is the most remarkable arena I have ever seen. As a football ground it is unrivalled in the world. It is an honour to Manchester.” is what The  Sporting Chronicle wrote about Old Trafford upon opening in February of 1910. Quite a welcome, but the stadium proved worthy of its reputation over the years. \n\nBefore moving to Old Trafford, the great Man United began as Newton Heath and only earned its current name after the old club dissolved in early 20th century. By 1909, just 7 years into its operation as United, owner of local brewery and chairman of the club, John Henry Davies, pumped £90,000 into construction of a brand new stadium with open-air embankments on three sides and a covered main grandstand in the south.\n\n“It is the most remarkable arena I have ever seen. As a football ground it is unrivalled in the world. It is an honour to Manchester.” is what The  Sporting Chronicle wrote about Old Trafford upon opening in February of 1910. Quite a welcome, but the stadium proved worthy of its reputation over the years. \n\nBefore moving to Old Trafford, the great Man United began as Newton Heath and only earned its current name after the old club dissolved in early 20th century. By 1909, just 7 years into its operation as United, owner of local brewery and chairman of the club, John Henry Davies, pumped £90,000 into construction of a brand new stadium with open-air embankments on three sides and a covered main grandstand in the south.";
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'History',
                style: boldTextStyle.copyWith(color: whiteColor, fontSize: 18),
              ),
            ),
            Text(text, style: regularTextStyle.copyWith(color: whiteColor)),
          ],
        ),
      );
    }

    Widget buildContent() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buildButton(), buildTitle()],
            ),
          ),
          buildCarousel(),
          buildInformation(),
          buildHistory(),
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
