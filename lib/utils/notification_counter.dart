import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCounter with ChangeNotifier {
  static final NotificationCounter _instance = NotificationCounter._internal();
  factory NotificationCounter() => _instance;
  NotificationCounter._internal() {
    _loadCount();
  }

  final _controller = StreamController<int>.broadcast();
  int _count = 0;
  int get count => _count;
  Stream<int> get stream => _controller.stream;
  bool isIncrementing = false;

  Future<void> incrementOne(String? notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    final lastId = prefs.getString('last_notification_id');

    if (notificationId == null || notificationId == lastId) return;
    await prefs.setString('last_notification_id', notificationId);
    await increment();
  }

  Future<void> _loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    _count = prefs.getInt('counter_notification') ?? 0;
    _controller.add(_count);
    notifyListeners();
  }

  Future<void> increment() async {
    if (isIncrementing) return;
    isIncrementing = true;

    final prefs = await SharedPreferences.getInstance();
    _count = (prefs.getInt('counter_notification') ?? 0) + 1;
    await prefs.setInt('counter_notification', _count);
    _controller.add(_count);
    notifyListeners();

    isIncrementing = false;
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    _count = 0;
    await prefs.setInt('counter_notification', _count);
    _controller.add(_count);
    notifyListeners();
  }

  Future<void> onAppResume() async {
    await _loadCount();
  }
}
