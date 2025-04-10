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

// import 'package:flutter/material.dart';
// import 'package:football_stadium/utils/theme.dart';

// class NewsScreen extends StatefulWidget {
//   const NewsScreen({super.key});

//   @override
//   State<NewsScreen> createState() => _NewsScreenState();
// }

// class _NewsScreenState extends State<NewsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 6,
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(color: adjustColor(backgroundColor)),
//           child: TabBar(
//             indicatorColor: whiteColor,
//             labelColor: whiteColor,
//             unselectedLabelColor: subtitleSecondColor,
//             isScrollable: true,
//             padding: EdgeInsets.zero,
//             indicator: BoxDecoration(),
//             tabAlignment: TabAlignment.start,
//             tabs: [
//               Tab(child: Text('Timnas', style: regularTextStyle)),
//               Tab(child: Text('Liga', style: regularTextStyle)),
//               Tab(child: Text('Klub', style: regularTextStyle)),
//               Tab(child: Text('Pemain', style: regularTextStyle)),
//               Tab(child: Text('Stadion', style: regularTextStyle)),
//               Tab(child: Text('Event', style: regularTextStyle)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
