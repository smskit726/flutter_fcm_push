import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push/helper/notification.dart';
import 'package:push/helper/push_message.dart';
import 'package:push/screen/home_screen.dart';

messageCallback(RemoteMessage remoteMessage) {
  NotificationHelper.showNotification(remoteMessage);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHelper.init();
  PushMessageHelper.init(messageCallback: messageCallback);
  runApp(const MyApp());
  NotificationHelper.requestPermission();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
