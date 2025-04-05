import 'package:flutter/material.dart';
import 'package:football_stadium/utils/theme.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Coming Soon',
        style: boldTextStyle.copyWith(color: whiteColor),
      ),
    );
  }
}
