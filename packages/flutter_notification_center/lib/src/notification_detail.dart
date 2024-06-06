import "package:flutter/material.dart";
import "package:flutter_notification_center/flutter_notification_center.dart";
import "package:intl/intl.dart";

/// A page displaying the details of a notification.
class NotificationDetailPage extends StatelessWidget {
  /// Creates a new [NotificationDetailPage] instance.
  ///
  /// The [notificationStyle] parameter specifies the notification style.
  ///
  /// The [notification] parameter specifies the notification
  ///  to display details for.
  const NotificationDetailPage({
    required this.notificationStyle,
    required this.notification,
    required this.translations,
    super.key,
  });

  /// The notification style.
  final NotificationStyle notificationStyle;

  /// The notification to display details for.
  final NotificationModel notification;

  /// The translations for the notification detail page.
  final NotificationTranslations translations;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          translations.appBarTitle,
          style: theme.appBarTheme.titleTextStyle,
        ),
        iconTheme: theme.appBarTheme.iconTheme ??
            const IconThemeData(color: Colors.white),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title,
                style: notificationStyle.titleTextStyle ?? const TextStyle(),
              ),
              const SizedBox(height: 10),
              Text(
                notification.body,
                style: notificationStyle.subtitleTextStyle ?? const TextStyle(),
              ),
              const SizedBox(height: 10),
              Text(
                "${translations.datePrefix}"
                ' ${DateFormat('yyyy-MM-dd HH:mm').format(
                  notification.dateTimePushed ?? DateTime.now(),
                )}',
                style: const TextStyle(
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
