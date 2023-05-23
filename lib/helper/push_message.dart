import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushMessageHelper {
  PushMessageHelper._();

  static Function(RemoteMessage)? _messageCallback;

  static void init({Function(RemoteMessage)? messageCallback}) async {
    _messageCallback = messageCallback;

    await Firebase.initializeApp();
    print("token ::::: ${await FirebaseMessaging.instance.getToken()}");
    // 백그라운드 수신
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // 포그라운드 수신
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
  }

  @pragma("vm:entry-point")
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Push Messaging Background Handler :: ${message.messageId}");
    _messageCallback?.call(message);
  }

  static void _firebaseMessagingForegroundHandler(RemoteMessage message) {
    // 안드로이드일 경우 notification 대신 보여주기
    print("Push Messaging Foreground Handler :: ${message.messageId}");
    if (Platform.isAndroid) {
      _messageCallback?.call(message);
    }
  }
}
