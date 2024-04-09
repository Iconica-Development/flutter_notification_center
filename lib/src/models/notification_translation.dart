/// Defines translations for notification messages.
class NotificationTranslations {
  /// The title to be displayed in the app bar of the notification center.
  final String appBarTitle;

  /// The message to be displayed when there are no unread notifications available.
  final String noNotifications;

  /// Creates a new [NotificationTranslations] instance.
  ///
  /// The [appBarTitle] parameter specifies the title to be displayed in the
  /// app bar of the notification center. The default value is 'Notification Center'.
  ///
  /// The [noNotifications] parameter specifies the message to be displayed when
  /// there are no unread notifications available. The default value is
  /// 'No unread notifications available.'.
  const NotificationTranslations({
    this.appBarTitle = 'Notification Center',
    this.noNotifications = 'No unread notifications available.',
  });
}
