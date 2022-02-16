import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static void Function(String? payload)? onSelectNotification = ((payload) {
    //TODO: Implementar navegación a lugares o detalles.
  });

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

    await _notifications.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
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
    final int _id =
        await getActiveNotifications().then((value) => value.length);

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
    final int _id =
        await getActiveNotifications().then((value) => value.length);
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

  static Future<List<ActiveNotification>> getActiveNotifications() async {
    return await _notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.getActiveNotifications() ??
        [];
  }
}
