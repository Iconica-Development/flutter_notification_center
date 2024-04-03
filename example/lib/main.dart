import 'package:flutter/material.dart';
import 'package:flutter_notification_center/flutter_notification_center.dart';

void main() {
  runApp(
    const MaterialApp(
      home: NotificationCenterDemo(),
    ),
  );
}

class NotificationCenterDemo extends StatelessWidget {
  const NotificationCenterDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notification Center'),
          centerTitle: true,
        ),
        body: NotificationCenter(
          key: key,
          notificationCenterService: NotificationService(listOfNotifications: [
            NotificationModel(
              title: 'Notification title 1',
              body: 'Notification body 1',
              dateTime: DateTime.now(),
              isRead: false,
            ),
            NotificationModel(
              title: 'RECURRING',
              body: 'RECURRING',
              dateTime: DateTime.now(),
              isRead: false,
              isScheduled: true,
            ),
            NotificationModel(
              title: 'Notification title 2',
              body: 'Notification body 2',
              dateTime: DateTime.now(),
              isRead: false,
            ),
            NotificationModel(
              title: 'Notification title 3',
              body: 'Notification body 3',
              dateTime: DateTime.now(),
              isRead: false,
            ),
          ]),
          notificationTheme: const NotificationStyle(
              titleTextStyle: TextStyle(color: Colors.red, fontSize: 20),
              subtitleTextStyle: TextStyle(color: Colors.blue, fontSize: 16),
              subtitleTextAlign: TextAlign.end),
        ));
  }
}
