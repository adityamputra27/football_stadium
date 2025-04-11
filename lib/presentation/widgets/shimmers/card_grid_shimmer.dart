import 'package:flutter/material.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:shimmer/shimmer.dart';

class CardGridShimmer extends StatelessWidget {
  final int itemCount;
  const CardGridShimmer({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(top: 24),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
        mainAxisExtent: 90,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: adjustColor(secondaryColor),
          highlightColor: adjustColor(thirdColor),
          child: Container(
            decoration: BoxDecoration(
              color: adjustColor(secondaryColor),
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
        );
      },
    );
  }
}
