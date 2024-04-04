import 'package:flutter/material.dart';
import 'package:flutter_notification_center/flutter_notification_center.dart';

void main() {
  runApp(
    const MaterialApp(
      home: NotificationCenterDemo(),
    ),
  );
}

class NotificationCenterDemo extends StatefulWidget {
  const NotificationCenterDemo({Key? key}) : super(key: key);

  @override
  State<NotificationCenterDemo> createState() => _NotificationCenterDemoState();
}

class _NotificationCenterDemoState extends State<NotificationCenterDemo> {
  var config = NotificationConfig(
    service: LocalNotificationService(
      listOfActiveNotifications: [
        NotificationModel(
          id: 1,
          title: 'Notification title 1',
          body: 'Notification body 1',
          dateTimePushed: DateTime.now(),
        ),
        NotificationModel(
          id: 2,
          title: 'RECURRING',
          body: 'RECURRING',
          dateTimePushed: DateTime.now(),
        ),
        NotificationModel(
          id: 3,
          title: 'Notification title 2',
          body: 'Notification body 2',
          dateTimePushed: DateTime.now(),
        ),
        NotificationModel(
          id: 4,
          title: 'Notification title 3',
          body: 'Notification body 3',
          dateTimePushed: DateTime.now(),
        ),
      ],
    ),
    style: const NotificationStyle(
        titleTextStyle: TextStyle(color: Colors.red, fontSize: 20),
        subtitleTextStyle: TextStyle(color: Colors.blue, fontSize: 16),
        subtitleTextAlign: TextAlign.end),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Center Demo'),
        centerTitle: true,
        actions: [
          NotificationBellWidgetStory(
            config: config,
          ),
        ],
      ),
      body: const SizedBox.shrink(),
    );
  }
}
