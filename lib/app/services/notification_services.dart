import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationServices {

  /// initialize notification services
  initializeNotification() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'inbox',
          channelName: 'Inbox Notification',
          channelDescription: 'Notification Testing',
        )
      ],
    );
  }

  /// check user notification permissions
  checkNotificationPermission() {
    try {
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });
    } catch (e) {
      print('exception :: $e');
    }
  }

  // Send a notification
  Future<void> sendNotification(
      String deviceToken, String message, String senderName) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: Random().nextInt(100),
          channelKey: 'inbox',
          title: senderName,
          body: message,),
    );
  }
}
