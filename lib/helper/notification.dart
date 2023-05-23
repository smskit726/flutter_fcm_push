import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  NotificationHelper._();
  static final FlutterLocalNotificationsPlugin _localNotificationPlugin = FlutterLocalNotificationsPlugin();

  static void init() async {
    /*
    * 안드로이드를 위한 채널 설정
    * 안드로이드는 앱이 켜져있고 사용중일 때는 기본적으로 알림을 막기때문에
    * Notification을 띄우기 위해서는 채널 설정이 필요하다.
    * */
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'flutter_push_channel_0', // ID
      'Flutter Push Message', // Title
      description: 'Push Sample Application Notification Channel',
      importance: Importance.max,
    );

    await _localNotificationPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotificationPlugin.initialize(settings);
  }

  static void requestPermission() {
    // IOS Permission
    _localNotificationPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(sound: true, badge: true, alert: true);

    // Android Permission
    _localNotificationPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static void showNotification(RemoteMessage remoteMessage) async {
    AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
      "flutter_push_channel_0",
      "Flutter Push Message",
      importance: Importance.max,
      priority: Priority.max,
    );

    DarwinNotificationDetails iosDetails =
        const DarwinNotificationDetails(presentBadge: true, presentSound: true, presentAlert: true);

    NotificationDetails details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    if (remoteMessage.notification != null) {
      String title = remoteMessage.notification?.title ?? "";
      String body = remoteMessage.notification?.body ?? "";

      _localNotificationPlugin.show(0, title, body, details);
    }
  }
}
