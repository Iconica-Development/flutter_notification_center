import 'package:flutter/material.dart';
import 'package:flutter_notification_center/flutter_notification_center.dart';
import 'package:intl/intl.dart';

/// A page displaying the details of a notification.
class NotificationDetailPage extends StatelessWidget {
  /// The notification configuration.
  final NotificationConfig config;

  /// The notification to display details for.
  final NotificationModel notification;

  /// Creates a new [NotificationDetailPage] instance.
  ///
  /// The [config] parameter specifies the notification configuration.
  ///
  /// The [notification] parameter specifies the notification to display details for.
  const NotificationDetailPage({
    required this.config,
    required this.notification,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          config.translations.appBarTitle,
          style: config.style.appTitleTextStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title,
                style: config.style.titleTextStyle ?? const TextStyle(),
              ),
              const SizedBox(height: 10),
              Text(
                notification.body,
                style: config.style.subtitleTextStyle ?? const TextStyle(),
              ),
              const SizedBox(height: 10),
              Text(
                'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(notification.dateTimePushed ?? DateTime.now())}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
