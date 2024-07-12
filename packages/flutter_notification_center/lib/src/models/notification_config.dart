import "package:flutter/material.dart";

import "package:flutter_notification_center/flutter_notification_center.dart";

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
    this.translations = const NotificationTranslations.empty(),
    this.notificationWidgetBuilder,
    this.showAsSnackBar = true,
    this.enableNotificationPopups = true,
    this.bellStyle = const AnimatedNotificationBellStyle(),
    this.pinnedIconColor = Colors.black,
    this.emptyNotificationsBuilder,
  });

  /// The notification service to use for delivering notifications.
  final NotificationService service;

  /// Translations for notification messages.
  final NotificationTranslations translations;

  /// Widget for building each notification item.
  final Widget Function(NotificationModel, BuildContext)?
      notificationWidgetBuilder;

  /// Whether to show notifications as snackbars.
  /// If false show notifications as a dialog.
  final bool showAsSnackBar;

  /// Whether to show notification popups.
  final bool enableNotificationPopups;

  /// The style of the notification bell.
  final AnimatedNotificationBellStyle bellStyle;

  /// The color of the trailing icon (if any) in the notification.
  final Color? pinnedIconColor;

  /// A builder function to display when there are no notifications.
  final Widget Function()? emptyNotificationsBuilder;
}
