import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:notification_center_repository_interface/notification_center_repository_interface.dart";

class NotificationSnackbar extends SnackBar {
  NotificationSnackbar({
    required String title,
    required String body,
    required NotificationTranslations translations,
    required VoidCallback onDismiss,
    super.key,
    DateTime? datetimePublished,
  }) : super(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                datetimePublished != null
                    ? DateFormat("dd-MM-yyyy HH:mm").format(datetimePublished)
                    : translations.notAvailable,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 50),
          action: SnackBarAction(
            label: translations.dissmissDialog,
            onPressed: onDismiss,
            textColor: Colors.white,
          ),
        );
}
