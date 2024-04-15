import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationSnackbar extends SnackBar {
  NotificationSnackbar({
    super.key,
    required String title,
    required String body,
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
                    ? DateFormat('dd MMM HH:mm').format(datetimePublished)
                    : 'N/A',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {},
            textColor: Colors.white,
          ),
        );
}
