import 'dart:async';

import 'package:blackbells/services/notification_service.dart';
import 'package:blackbells/providers/socket_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pushNotificationProvider =
    Provider(((ref) => PushNotificationService(read: ref.read)));

class PushNotificationService {
  PushNotificationService({required this.read});

  final Reader read;
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  // static StreamController<String> _messageStream = StreamController.broadcast();
  // static Stream<String> get messageStream => _messageStream.stream;

  static Future _onBackgroundHandler(RemoteMessage message) async {}

  static Future _onMessageHandler(RemoteMessage message) async {
    NotificationService.showNotification(
      title: message.notification!.title,
      body: message.notification!.body,
    );
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    // print('_onMessageOpenApp: ${message.notification!.title}');
    // _messageStream.add(message.notification.title);
  }

  Future initializeApp() async {
    // Push Notifications
    await Firebase.initializeApp();
    await requestPermissions();

    token = await FirebaseMessaging.instance.getToken();
    // Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    await Future.delayed(const Duration(seconds: 1));
    read(socketProvider).emit('update-notification-token', token);
    // Local Notifications
  }

  static Future<void> requestPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      messaging.subscribeToTopic('notifications');
    }
  }

  // static closeStreams() {
  //   _messageStream.close();
  // }
}
