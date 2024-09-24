import "package:notification_center_repository_interface/notification_center_repository_interface.dart";

abstract class NotificationRepositoryInterface {
  Future<NotificationModel> addNotification(
    String userId,
    NotificationModel notification,
    List<String> recipientIds,
  );

  Stream<NotificationModel?> getNotification(String userId, String id);

  Stream<List<NotificationModel>> getNotifications(String userId);

  Stream<List<NotificationModel>> getPlannedNotifications(String userId);

  Future<NotificationModel> updateNotification(
    String userId,
    NotificationModel notification,
  );

  Future<void> deleteNotification(
    String userId,
    String id,
    // ignore: avoid_positional_boolean_parameters
    bool planned,
  );
}
