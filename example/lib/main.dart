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
          notificationCenterService:
              LocalNotificationService(listOfActiveNotifications: [
            NotificationModel(
              id: 1,
              title: 'Notification title 1',
              body: 'Notification body 1',
              dateTimePushed: DateTime.now(),
            ),
            NotificationModel(
              id: 2,
              title: 'Notification title 2',
              body: 'Notification body 2',
              dateTimePushed: DateTime.now(),
            ),
          ]),
          notificationTheme: const NotificationStyle(
              titleTextStyle: TextStyle(color: Colors.red, fontSize: 20),
              subtitleTextStyle: TextStyle(color: Colors.blue, fontSize: 16),
              subtitleTextAlign: TextAlign.end),
        ));
  }
}
