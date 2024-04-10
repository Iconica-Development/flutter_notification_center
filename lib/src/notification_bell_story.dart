import "package:flutter/material.dart";
import "package:flutter_notification_center/flutter_notification_center.dart";

/// A widget representing a notification bell.
class NotificationBellWidgetStory extends StatelessWidget {
  /// Creates a new [NotificationBellWidgetStory] instance.
  ///
  /// The [config] parameter specifies the notification configuration.
  const NotificationBellWidgetStory({
    required this.config,
    super.key,
  });

  /// The notification configuration.
  final NotificationConfig config;

  @override
  Widget build(BuildContext context) => NotificationBell(
        config: config,
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NotificationCenter(
                config: config,
              ),
            ),
          );
        },
      );
}
