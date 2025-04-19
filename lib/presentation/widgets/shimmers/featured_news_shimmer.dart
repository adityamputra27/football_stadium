import 'package:flutter/material.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedNewsShimmer extends StatefulWidget {
  const FeaturedNewsShimmer({super.key});

  @override
  State<FeaturedNewsShimmer> createState() => _FeaturedNewsShimmerState();
}

class _FeaturedNewsShimmerState extends State<FeaturedNewsShimmer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: adjustColor(secondaryColor),
      highlightColor: adjustColor(thirdColor),
      child: Container(
        width: 250,
        height: 180,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: adjustColor(secondaryColor),
        ),
      ),
    );
  }
}
