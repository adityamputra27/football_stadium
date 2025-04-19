import 'package:flutter/material.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:shimmer/shimmer.dart';

class LatestNewsShimmer extends StatefulWidget {
  const LatestNewsShimmer({super.key});

  @override
  State<LatestNewsShimmer> createState() => _LatestNewsShimmerState();
}

class _LatestNewsShimmerState extends State<LatestNewsShimmer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: adjustColor(secondaryColor),
      highlightColor: adjustColor(thirdColor),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: adjustColor(secondaryColor),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 15,
                    decoration: BoxDecoration(
                      color: adjustColor(secondaryColor),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 200,
                    height: 15,
                    decoration: BoxDecoration(
                      color: adjustColor(secondaryColor),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 75,
                    height: 15,
                    decoration: BoxDecoration(
                      color: adjustColor(secondaryColor),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
