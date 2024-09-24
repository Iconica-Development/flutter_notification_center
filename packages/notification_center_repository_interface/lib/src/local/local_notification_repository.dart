import "dart:async";

import "package:notification_center_repository_interface/src/interfaces/notification_repository_interface.dart";
import "package:notification_center_repository_interface/src/models/notification.dart";
import "package:rxdart/rxdart.dart";

class LocalNotificationRepository implements NotificationRepositoryInterface {
  final List<NotificationModel> _activeNotifications = [];
  final List<NotificationModel> _plannedNotifications = [];

  final StreamController<List<NotificationModel>> _notificationsController =
      BehaviorSubject<List<NotificationModel>>();

  final StreamController<List<NotificationModel>>
      _plannedNotificationsController =
      BehaviorSubject<List<NotificationModel>>();

  final StreamController<NotificationModel> _notificationController =
      BehaviorSubject<NotificationModel>();

  @override
  Future<NotificationModel> addNotification(
    String userId,
    NotificationModel notification,
    List<String> recipientIds,
  ) async {
    if (notification.scheduledFor != null &&
        notification.scheduledFor!.isAfter(DateTime.now())) {
      _plannedNotifications.add(notification);
    } else {
      _activeNotifications.add(notification);
    }

    getNotifications(userId);

    return notification;
  }

  @override
  Future<void> deleteNotification(
    String userId,
    String id,
    bool planned,
  ) async {
    if (planned) {
      _plannedNotifications.removeWhere((element) => element.id == id);
    } else {
      _activeNotifications.removeWhere((element) => element.id == id);
    }

    getNotifications(userId);
  }

  @override
  Stream<NotificationModel?> getNotification(String userId, String id) {
    var notification = _activeNotifications.firstWhere(
      (element) => element.id == id,
    );

    _notificationController.add(notification);

    return _notificationController.stream;
  }

  @override
  Stream<List<NotificationModel>> getNotifications(String userId) {
    _notificationsController.add(_activeNotifications);

    return _notificationsController.stream;
  }

  @override
  Stream<List<NotificationModel>> getPlannedNotifications(String userId) {
    _plannedNotificationsController.add(_plannedNotifications);

    return _plannedNotificationsController.stream;
  }

  @override
  Future<NotificationModel> updateNotification(
    String userId,
    NotificationModel notification,
  ) async {
    _activeNotifications
        .removeWhere((element) => element.id == notification.id);

    _activeNotifications.add(notification);
    getNotifications(userId);

    return notification;
  }
}
