// Define a PopupHandler class to handle notification popups
import 'package:flutter/material.dart';

import 'package:flutter_notification_center/flutter_notification_center.dart';

class PopupHandler {
  final BuildContext context;
  final NotificationConfig config;

  PopupHandler({
    required this.context,
    required this.config,
  });

  void handleNotificationPopup(NotificationModel notification) {
    if (!config.enableNotificationPopups) return;

    if (config.showAsSnackBar) {
      ScaffoldMessenger.of(context).showSnackBar(
        NotificationSnackbar(
          title: notification.title,
          body: notification.body,
          datetimePublished: DateTime.now(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => NotificationDialog(
          title: notification.title,
          body: notification.body,
          datetimePublished: notification.dateTimePushed,
        ),
      );
    }
  }
}
