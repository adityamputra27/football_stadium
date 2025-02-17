import 'package:flutter/material.dart';
import 'package:football_stadium/presentation/screens/main_screen.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/route_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var isLoading = false;

  void startLoading() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = true;
      });
    });
  }

  void finishLoading() {
    Future.delayed(Duration(seconds: 5), () {
      Get.to(
        () => const MainScreen(activeIndex: 0),
        transition: Transition.rightToLeft,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    startLoading();
    finishLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: EdgeInsets.all(15),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/stadium-logo.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                    ],
                  ),
                  isLoading
                      ? Container(
                        padding: EdgeInsets.only(top: 32),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: primaryColor,
                            strokeWidth: 4,
                          ),
                        ),
                      )
                      : Container(
                        padding: EdgeInsets.only(top: 56),
                        child: SizedBox(),
                      ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'v1.0.0',
                    style: regularTextStyle.copyWith(color: whiteColor),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
