import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:football_stadium/data/database/notification_database.dart';
import 'package:football_stadium/data/models/local_notification_model.dart';
import 'package:football_stadium/utils/environment.dart';
import 'package:football_stadium/utils/notification_counter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
  NotificationResponse notificationResponse,
) {
  if (kDebugMode) {
    print(notificationResponse);
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationCounter().incrementOne(message.messageId);
}

class NotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final Map<String, String> _firebaseTopicNotifications = {
    'topic_football_stadium': 'Football Stadium',
    'topic_football_league': 'Football League',
    'topic_football_player': 'Football Player',
    'topic_football_club': 'Football Club',
    'topic_football_match': 'Football Match',
    'topic_football_news': 'Football News',
    'topic_football_event': 'Football Event',
    'topic_welcome': 'Welcome',
  };

  void initLocalNotifications(
    BuildContext context,
    RemoteMessage message,
  ) async {
    var androidInitializationSettings = AndroidInitializationSettings(
      '@drawable/ic_notification',
    );
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
      }

      NotificationCounter().incrementOne(message.messageId);

      initLocalNotifications(context, message);
      showNotification(message);
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   NotificationCounter().incrementOne(message.messageId);
    // });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> subscribeToAllTopics() async {
    for (final firebaseTopicNotification in _firebaseTopicNotifications.keys) {
      await messaging.subscribeToTopic(firebaseTopicNotification);
    }
  }

  Future<void> toggleSubscription(String category, bool subcribe) async {
    if (_firebaseTopicNotifications.containsKey(category) && subcribe) {
      await messaging.subscribeToTopic(category);
    } else {
      await messaging.unsubscribeFromTopic(category);
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          icon: '@drawable/ic_notification',
          channel.id.toString(),
          channel.name.toString(),
          importance: Importance.high,
          priority: Priority.high,
          playSound: false,
          ticker: 'ticker',
          color: const Color(0xff0A141B),
          colorized: true,
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });

    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // int currentCountNotification =
    //     sharedPreferences.getInt('counter_notification') ?? 0;

    if (message.notification != null) {
      var uuid = Uuid();
      final id = uuid.v4();
      final title = message.notification!.title.toString();
      final body = message.notification!.body.toString();
      final timestamp = DateTime.now().toIso8601String();

      final notificationPayload = LocalNotificationModel(
        id: id,
        title: title,
        body: body,
        timestamp: timestamp,
        isRead: false,
        isDeleted: false,
      );

      // await sharedPreferences.setInt(
      //   'counter_notification',
      //   currentCountNotification + 1,
      // );

      await NotificationDatabase.instance.insertNotification(
        notificationPayload,
      );
    }
  }

  void requestNotificationPermission(Function(bool) onResult) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: false,
    );

    bool isGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (isGranted) {
      await initialUser();
      await sendFirstNotification();
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
    }

    onResult(isGranted);
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  Future<Map<String, bool>> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'topic_football_stadium': prefs.getBool('topic_football_stadium') ?? true,
      'topic_football_league': prefs.getBool('topic_football_league') ?? true,
      'topic_football_player': prefs.getBool('topic_football_player') ?? true,
      'topic_football_club': prefs.getBool('topic_football_club') ?? true,
      'topic_football_match': prefs.getBool('topic_football_match') ?? true,
      'topic_football_news': prefs.getBool('topic_football_news') ?? true,
      'topic_football_event': prefs.getBool('topic_football_event') ?? true,
    };
  }

  Future<void> savePreferences(Map<String, bool> prefs) async {
    final storage = await SharedPreferences.getInstance();
    await Future.wait([
      storage.setBool(
        'topic_football_stadium',
        prefs['topic_football_stadium']!,
      ),
      storage.setBool('topic_football_league', prefs['topic_football_league']!),
      storage.setBool('topic_football_player', prefs['topic_football_player']!),
      storage.setBool('topic_football_club', prefs['topic_football_club']!),
      storage.setBool('topic_football_match', prefs['topic_football_match']!),
      storage.setBool('topic_football_news', prefs['topic_football_news']!),
      storage.setBool('topic_football_event', prefs['topic_football_event']!),
    ]);
  }

  Future<bool> sendFirstNotification() async {
    final prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt('user_id')!;
    String firebaseCloudMessagingToken = await getDeviceToken();

    final response = await http.post(
      Uri.parse("${Environment.baseURL}/first-notification-device"),
      headers: <String, String>{
        'Football-Stadium-App': Environment.valueHeader,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'fcm_token': firebaseCloudMessagingToken,
      }),
    );

    var responseData = jsonDecode(response.body);
    return responseData['data']['status'];
  }

  Future<void> initialUser() async {
    String deviceId = '-';
    String token = await getDeviceToken();

    if (token.isNotEmpty) {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo =
            await deviceInfoPlugin.androidInfo;
        deviceId = androidDeviceInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosDeviceInfo.localizedModel;
      }

      final response = await http.post(
        Uri.parse("${Environment.baseURL}/register-device"),
        headers: <String, String>{
          'Football-Stadium-App': Environment.valueHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'device_id': deviceId, 'fcm_token': token}),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();

      dynamic responseData = jsonDecode(response.body);
      bool responseStatus = responseData['data']['status'];
      int responseUserId = responseData['data']['data']['id'];

      bool isNewDevice = responseData['data']['is_new_device'];
      prefs.setBool('is_new_device', isNewDevice);

      if (isNewDevice) {
        final prefs = await loadPreferences();
        await subscribeToAllTopics();
        await savePreferences(prefs);
      }

      if (responseStatus) {
        prefs.setInt('user_id', responseUserId);
      } else {
        prefs.setInt('user_id', 0);
      }
    }
  }
}
