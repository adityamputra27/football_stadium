import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
  NotificationResponse notificationResponse,
) {
  if (kDebugMode) {
    print(notificationResponse);
  }
}

class NotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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

      initLocalNotifications(context, message);
      showNotification(message);
    });
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
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permissions');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      if (kDebugMode) {
        print('user denied permission');
      }
    }
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
}
