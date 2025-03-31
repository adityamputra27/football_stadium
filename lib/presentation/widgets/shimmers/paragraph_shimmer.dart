import 'package:flutter/material.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:shimmer/shimmer.dart';

class ParagraphShimmer extends StatelessWidget {
  final double customWidth;
  final double customHeight;
  final double customMarginTop;
  const ParagraphShimmer({
    super.key,
    required this.customWidth,
    required this.customHeight,
    this.customMarginTop = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: secondaryColor,
      highlightColor: thirdColor,
      child: Container(
        width: customWidth,
        height: customHeight,
        margin: EdgeInsets.only(left: 15, right: 15, top: customMarginTop),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
    );
  }
}
