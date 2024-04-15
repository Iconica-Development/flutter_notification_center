import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationDialog extends StatelessWidget {
  final String title;
  final String body;
  final DateTime? datetimePublished;

  const NotificationDialog({
    super.key,
    required this.title,
    required this.body,
    this.datetimePublished,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDateTime = datetimePublished != null
        ? DateFormat('dd MMM HH:mm').format(datetimePublished!)
        : 'N/A';

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
          child: const Text(
            'Dismiss',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
