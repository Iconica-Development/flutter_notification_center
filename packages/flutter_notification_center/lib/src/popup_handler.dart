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
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        NotificationSnackbar(
          title: notification.title,
          body: notification.body,
          translations: config.translations,
          onDismiss: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          datetimePublished: DateTime.now(),
        ),
      );
    } else {
      if (ModalRoute.of(context)?.isCurrent != true) return;

      showDialog(
        context: context,
        builder: (context) => NotificationDialog(
          translations: config.translations,
          title: notification.title,
          body: notification.body,
          datetimePublished: notification.dateTimePushed,
        ),
      );
    }
  }
}
