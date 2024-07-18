/// Defines translations for notification messages.
class NotificationTranslations {
  /// Creates a new [NotificationTranslations] instance.
  const NotificationTranslations({
    required this.appBarTitle,
    required this.noNotifications,
    required this.notificationDismissed,
    required this.notificationPinned,
    required this.notificationUnpinned,
    required this.errorMessage,
    required this.datePrefix,
    required this.notAvailable,
    required this.dissmissDialog,
  });

  const NotificationTranslations.empty({
    this.appBarTitle = "notifications",
    this.noNotifications = "No unread notifications available.",
    this.notificationDismissed = "Notification dismissed.",
    this.notificationPinned = "Notification pinned.",
    this.notificationUnpinned = "Notification unpinned.",
    this.errorMessage = "An error occurred. Please try again later.",
    this.datePrefix = "Date:",
    this.notAvailable = "N/A",
    this.dissmissDialog = "Dismiss",
  });

  /// The title to be displayed in the app bar of the notification center.
  final String appBarTitle;

  /// The message to be displayed when there are no unread
  ///  notifications available.
  final String noNotifications;

  /// The message to be displayed when a notification is dismissed.
  final String notificationDismissed;

  /// The message to be displayed when a notification is pinned.
  final String notificationPinned;

  /// The message to be displayed when a notification is unpinned.
  final String notificationUnpinned;

  /// The message to be displayed when an error occurs.
  final String errorMessage;

  /// The message to be displayed before the date of a notification.
  final String datePrefix;

  /// The message to be displayed when parsing of the date fails
  final String notAvailable;

  /// The message to be displayed on the dismiss dialog / snackbar
  final String dissmissDialog;

  NotificationTranslations copyWith({
    String? appBarTitle,
    String? noNotifications,
    String? notificationDismissed,
    String? notificationPinned,
    String? notificationUnpinned,
    String? errorMessage,
    String? datePrefix,
    String? notAvailable,
    String? dissmissDialog,
  }) =>
      NotificationTranslations(
        appBarTitle: appBarTitle ?? this.appBarTitle,
        noNotifications: noNotifications ?? this.noNotifications,
        notificationDismissed:
            notificationDismissed ?? this.notificationDismissed,
        notificationPinned: notificationPinned ?? this.notificationPinned,
        notificationUnpinned: notificationUnpinned ?? this.notificationUnpinned,
        errorMessage: errorMessage ?? this.errorMessage,
        datePrefix: datePrefix ?? this.datePrefix,
        notAvailable: notAvailable ?? this.notAvailable,
        dissmissDialog: dissmissDialog ?? this.dissmissDialog,
      );
}
