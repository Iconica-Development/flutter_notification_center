import "dart:async";

import "package:notification_center_repository_interface/src/interfaces/notification_repository_interface.dart";
import "package:notification_center_repository_interface/src/local/local_notification_repository.dart";
import "package:notification_center_repository_interface/src/models/notification.dart";

class NotificationService {
  NotificationService({
    required this.userId,
    this.pollingInterval = const Duration(seconds: 15),
    NotificationRepositoryInterface? repository,
    this.onNewNotification,
  }) : repository = repository ?? LocalNotificationRepository() {
    unawaited(_startTimer());
  }

  final NotificationRepositoryInterface repository;
  final Function(NotificationModel)? onNewNotification;
  final String userId;
  final Duration pollingInterval;

  Timer? timer;

  Future<void> _startTimer() async {
    timer = Timer.periodic(pollingInterval, (timer) async {
      await checkForScheduledNotifications();
    });
  }

  /// Pushes a notification to the service.
  Future<void> pushNotification(
    NotificationModel notification,
    List<String> recipientIds,
  ) {
    var result = repository.addNotification(
      userId,
      notification,
      recipientIds,
    );

    if (recipientIds.contains(userId)) {
      getActiveNotifications();

      //Show popup with notification conte
      if (onNewNotification != null) {
        onNewNotification!.call(notification);
      }
    }

    return result;
  }

  /// Retrieves the list of active notifications.
  Stream<List<NotificationModel>> getActiveNotifications() =>
      repository.getNotifications(userId);

  /// Retrieves the list of planned notifications.
  Stream<List<NotificationModel>> getPlannedNotifications() =>
      repository.getPlannedNotifications(userId);

  /// Creates a scheduled notification.
  Future<void> createScheduledNotification(
    NotificationModel notification,
    List<String> recipientIds,
  ) async =>
      pushNotification(
        notification,
        recipientIds,
      );

  /// Creates a recurring notification.
  Future<void> createRecurringNotification(
    NotificationModel notification,
    List<String> recipientIds,
  ) async {
    if (notification.recurring) {
      switch (notification.occuringInterval) {
        case OcurringInterval.daily:
          notification.scheduledFor =
              DateTime.now().add(const Duration(days: 1));

        case OcurringInterval.weekly:
          notification.scheduledFor =
              DateTime.now().add(const Duration(days: 7));

        case OcurringInterval.monthly:
          notification.scheduledFor =
              DateTime.now().add(const Duration(days: 30));

        case OcurringInterval.debug:
          notification.scheduledFor =
              DateTime.now().add(const Duration(seconds: 10));

        case null:
      }
      await createScheduledNotification(notification, recipientIds);
    }
  }

  /// Deletes a scheduled notification.
  Future<void> deletePlannedNotification(NotificationModel notification) =>
      repository.deleteNotification(userId, notification.id, true);

  /// Dismisses an active notification.
  Future<void> dismissActiveNotification(NotificationModel notification) =>
      repository.deleteNotification(userId, notification.id, false);

  /// Pin an active notification.
  Future<void> pinActiveNotification(NotificationModel notification) =>
      repository.updateNotification(
        userId,
        notification.copyWith(isPinned: true),
      );

  /// Unpin an active notification.
  Future<void> unPinActiveNotification(NotificationModel notification) =>
      repository.updateNotification(
        userId,
        notification.copyWith(isPinned: false),
      );

  /// Marks a notification as read.
  Future<void> markNotificationAsRead(NotificationModel notification) =>
      repository.updateNotification(
        userId,
        notification.copyWith(isRead: true),
      );

  /// Checks for scheduled notifications.
  Future<void> checkForScheduledNotifications() async {
    var notifications = await repository.getPlannedNotifications(userId).first;

    for (var notification in notifications) {
      if (notification.scheduledFor != null &&
              notification.scheduledFor!.isBefore(DateTime.now()) ||
          notification.scheduledFor!.isAtSameMomentAs(DateTime.now())) {
        await pushNotification(
          notification,
          [userId],
        );

        await deletePlannedNotification(notification);
        if (notification.recurring) {
          await createRecurringNotification(
            notification,
            [userId],
          );
        }
      }
    }
  }

  /// Returns a stream of the number of active notifications.
  Stream<int> getActiveAmountStream() => repository
      .getNotifications(userId)
      .map((notifications) => notifications.length);
}
