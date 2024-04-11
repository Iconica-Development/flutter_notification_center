import 'package:flutter/material.dart';

import '../../flutter_notification_center.dart';

/// Configuration class for notifications.
class NotificationConfig {
  /// Creates a new [NotificationConfig] instance.
  ///
  /// The [service] parameter is required and specifies the notification service
  /// to use. The [style] parameter is optional and defines the style of the
  /// notification. The [translations] parameter is also optional and provides
  /// translations for notification messages.
  const NotificationConfig({
    required this.service,
    required this.seperateNotificationsWithDivider,
    this.translations = const NotificationTranslations(),
    required this.notificationWidgetBuilder,
  });

  /// The notification service to use for delivering notifications.
  final NotificationService service;

  /// Whether to seperate notifications with a divider.
  final bool seperateNotificationsWithDivider;

  /// Translations for notification messages.
  final NotificationTranslations translations;

  /// Widget for building each notification item.
  final Widget Function(NotificationModel, BuildContext)
      notificationWidgetBuilder;
}
