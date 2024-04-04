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
    service: NotificationService(
      listOfNotifications: [
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
