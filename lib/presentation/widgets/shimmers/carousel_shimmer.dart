import 'package:flutter/material.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:shimmer/shimmer.dart';

class CarouselShimmer extends StatelessWidget {
  final double customMarginTop;
  final double customMarginBottom;

  const CarouselShimmer({
    super.key,
    this.customMarginTop = 34,
    this.customMarginBottom = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: secondaryColor,
      highlightColor: thirdColor,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 188,
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          top: customMarginTop,
          bottom: customMarginBottom,
        ),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
    );
  }
}
