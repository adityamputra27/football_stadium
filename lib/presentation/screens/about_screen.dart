import 'package:flutter/material.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appVersion = '';
  String appBuildNumber = '';

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
      appBuildNumber = packageInfo.buildNumber;
    });
  }

  @override
  void initState() {
    super.initState();
    getPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'About This App',
            style: boldTextStyle.copyWith(fontSize: 16, color: whiteColor),
          ),
          const SizedBox(height: 16),
          Text(
            'This app provides information about football and stadiums around the world. '
            'The data is sourced from stadiumdb.com, a comprehensive database of stadiums.',
            style: regularTextStyle.copyWith(
              fontSize: 14,
              color: subtitleColor,
            ),
          ),
          // const SizedBox(height: 16),
          // Text(
          //   'Source :',
          //   style: mediumTextStyle.copyWith(fontSize: 16, color: whiteColor),
          // ),
          // const SizedBox(height: 8),
          // GestureDetector(
          //   onTap: () {
          //     launchUrl(Uri.parse('https://stadiumdb.com/'));
          //   },
          //   child: Text(
          //     'stadiumdb.com',
          //     style: regularTextStyle.copyWith(
          //       fontSize: 14,
          //       color: primaryColor,
          //       decoration: TextDecoration.underline,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 16),
          Text(
            'v${appVersion.toString()} (${appBuildNumber.toString()})',
            style: regularTextStyle.copyWith(
              fontSize: 14,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
