import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_notification_center/src/models/notification.dart";

/// An abstract class representing a service for managing notifications.
abstract class NotificationService with ChangeNotifier {
  /// Creates a new [NotificationService] instance.
  ///
  /// The [listOfActiveNotifications] parameter specifies the
  ///  list of active notifications,
  /// with a default value of an empty list.
  ///
  /// The [listOfPlannedNotifications] parameter specifies the
  ///  list of planned notifications,
  /// with a default value of an empty list.
  NotificationService({
    this.listOfActiveNotifications = const [],
    this.listOfPlannedNotifications = const [],
  });

  /// A list of active notifications.
  List<NotificationModel> listOfActiveNotifications;

  /// A list of planned notifications.
  List<NotificationModel> listOfPlannedNotifications;

  /// Pushes a notification to the service.
  Future pushNotification(NotificationModel notification);

  /// Retrieves the list of active notifications.
  Future<List<NotificationModel>> getActiveNotifications();

  /// Creates a scheduled notification.
  Future createScheduledNotification(NotificationModel notification);

  /// Creates a recurring notification.
  Future createRecurringNotification(NotificationModel notification);

  /// Deletes a scheduled notification.
  Future deleteScheduledNotification(NotificationModel notification);

  /// Dismisses an active notification.
  Future dismissActiveNotification(NotificationModel notification);

  /// Marks a notification as read.
  Future markNotificationAsRead(NotificationModel notification);

  /// Checks for scheduled notifications.
  Future checkForScheduledNotifications();
}
