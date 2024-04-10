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
    this.style = const NotificationStyle(),
    this.translations = const NotificationTranslations(),
  });

  /// The notification service to use for delivering notifications.
  final NotificationService service;

  /// The style of the notification.
  final NotificationStyle style;

  /// Translations for notification messages.
  final NotificationTranslations translations;
}
