import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_logo');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await _notifications.initialize(initializationSettings);
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_channel',
        'Notificaciones importantes para Blackbells',
        channelDescription: 'channel description',
        importance: Importance.max,
        largeIcon: DrawableResourceAndroidBitmap('logo'),
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future<void> showNotification({
    String? title,
    String? body,
    String? payload,
  }) async {
    final int _id = await getActiveNotifications();

    return _notifications.show(
      _id + 1,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  static Future<void> showScheduleNotification({
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async {
    final int _id = await getActiveNotifications();
    return _notifications.zonedSchedule(
        _id + 1,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  static Future<int> getActiveNotifications() async {
    return await _notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.getActiveNotifications()
            .then(
              (value) => value != null ? value.length : 0,
            ) ??
        0;
  }
}
