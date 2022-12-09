import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

final notifications = FlutterLocalNotificationsPlugin();

initNotification() async {
  var androidSetting = AndroidInitializationSettings('app_icon');
  var initializationSettings = InitializationSettings(android: androidSetting);
  await notifications.initialize(initializationSettings);
}

Future onSelectNotification(String payload) async {}

showNorification() async {
  var androidDetails = AndroidNotificationDetails(
    'channelId',
    'channelName',
    priority: Priority.high,
    importance: Importance.max,
    color: Colors.redAccent[200],
  );
  notifications.show(
      1, '경고', '침수가 발생했습니다.', NotificationDetails(android: androidDetails));
}
