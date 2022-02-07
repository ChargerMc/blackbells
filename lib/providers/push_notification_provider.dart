import 'dart:async';

import 'package:blackbells/providers/snackbar_provider.dart';
import 'package:blackbells/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PushNotificationProvider {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  // static StreamController<String> _messageStream = StreamController.broadcast();
  // static Stream<String> get messageStream => _messageStream.stream;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    // print('background handler: ${message.messageId}');
    // _messageStream.add(message.notification.title);
    // print('Post ID:');
    // print(message.data['post_id'] + message.data['post_type']);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    SnackService.showBanner(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      leading: const CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
            'https://app.blackbells.com.ec/uploads/no-image.png'),
        backgroundColor: blackbellsColor,
      ),
      backgroundColor: Colors.white,
      contentTextStyle: const TextStyle(color: blackbellsColor),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${message.notification?.title}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text('${message.notification?.body}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => SnackService.close(),
          child: const Text(
            'Cerrar',
            style: TextStyle(
              color: Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
    // print('_onMessageHandler: ${message.notification!.title}');
    // _messageStream.add(message.notification.title);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    // print('_onMessageOpenApp: ${message.notification!.title}');
    // _messageStream.add(message.notification.title);
  }

  static Future initializeApp() async {
    // Push Notifications
    await Firebase.initializeApp();
    await requestPermissions();

    token = await FirebaseMessaging.instance.getToken();
    // print(token);

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

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
