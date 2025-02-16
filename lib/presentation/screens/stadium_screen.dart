import 'package:flutter/material.dart';
import 'package:football_stadium/utils/theme.dart';

class StadiumScreen extends StatefulWidget {
  const StadiumScreen({super.key});

  @override
  State<StadiumScreen> createState() => _StadiumScreenState();
}

class _StadiumScreenState extends State<StadiumScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Testing Stadium',
        style: boldTextStyle.copyWith(color: whiteColor),
      ),
    );
  }
}
