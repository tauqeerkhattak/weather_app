import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static Future<void> initializeNotifications() async {
    final AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: null,
      macOS: null,
    );

    await notifications.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotifications,
    );
  }

  static Future<void> showNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      '12356',
      'My notification',
      channelDescription: 'This is a notification',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: android,
    );

    await notifications.periodicallyShow(
      12345,
      'Is it sunny outside?',
      'Check out today\'s weather!',
      RepeatInterval.daily,
      notificationDetails,
    );
  }

  static Future onSelectNotifications(String? payload) async {
    print('Opened Notification!');
  }
}
