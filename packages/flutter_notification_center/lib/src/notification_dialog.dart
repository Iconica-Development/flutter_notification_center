import "package:flutter/material.dart";
import "package:flutter_notification_center/flutter_notification_center.dart";
import "package:intl/intl.dart";

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({
    required this.title,
    required this.body,
    required this.translations,
    super.key,
    this.datetimePublished,
  });
  final String title;
  final String body;
  final DateTime? datetimePublished;
  final NotificationTranslations translations;

  @override
  Widget build(BuildContext context) {
    var formattedDateTime = datetimePublished != null
        ? DateFormat("dd MMM HH:mm").format(datetimePublished!)
        : translations.notAvailable;

    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formattedDateTime,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            translations.dissmissDialog,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
