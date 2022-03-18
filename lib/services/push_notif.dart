import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin notifPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('logo'));
    notifPlugin.initialize(initializationSettings);
  }

  static Future<void> display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              'easyApproach', 'easyApproach channel',
              importance: Importance.high));
      await notifPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails);
    } on Exception catch (e) {
      print(e);
    }
  }
}
