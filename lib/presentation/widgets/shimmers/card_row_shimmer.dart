import 'package:flutter/material.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:shimmer/shimmer.dart';

class CardRowShimmer extends StatelessWidget {
  final int itemCount;
  final double height;
  final double radius;
  const CardRowShimmer({
    super.key,
    this.itemCount = 3,
    this.height = 70,
    this.radius = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: adjustColor(secondaryColor),
      highlightColor: adjustColor(thirdColor),
      child: GridView.builder(
        padding: EdgeInsets.only(top: 24),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
          mainAxisExtent: height,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            height: 20,
            decoration: BoxDecoration(
              color: adjustColor(whiteColor),
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
          );
        },
      ),
    );
  }
}
