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
    this.seperateNotificationsWithDivider = true,
    this.translations = const NotificationTranslations(),
    this.notificationWidgetBuilder,
    this.showAsSnackBar = true,
  });

  /// The notification service to use for delivering notifications.
  final NotificationService service;

  /// Whether to seperate notifications with a divider.
  final bool seperateNotificationsWithDivider;

  /// Translations for notification messages.
  final NotificationTranslations translations;

  /// Widget for building each notification item.
  final Widget Function(NotificationModel, BuildContext)?
      notificationWidgetBuilder;

  /// Whether to show notifications as snackbars. If false show notifications as a dialog.
  final bool showAsSnackBar;
}
