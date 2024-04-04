import 'package:flutter/material.dart';
import 'package:flutter_notification_center/flutter_notification_center.dart';

class NotificationBellWidgetStory extends StatelessWidget {
  const NotificationBellWidgetStory({
    required this.config,
    super.key,
  });

  final NotificationConfig config;

  @override
  Widget build(BuildContext context) {
    return NotificationBell(
      config: config,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NotificationCenter(
              config: config,
            ),
          ),
        );
      },
    );
  }
}
