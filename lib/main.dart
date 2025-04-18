import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:football_stadium/data/services/notification_service.dart';
import 'package:football_stadium/firebase_options.dart';
import 'package:football_stadium/presentation/screens/splash_screen.dart';
import 'package:football_stadium/utils/notification_counter.dart';
import 'package:football_stadium/utils/theme.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  MobileAds.instance.initialize();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NotificationCounter())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return GetMaterialApp(
      navigatorKey: NotificationService().navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Football Stadium in the World',
      home: SplashScreen(),
      theme: ThemeData(scaffoldBackgroundColor: backgroundColor),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(highContrast: false, invertColors: false),
          child: child!,
        );
      },
    );
  }
}
