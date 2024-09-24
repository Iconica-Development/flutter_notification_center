import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_core/firebase_core.dart";
import "package:notification_center_repository_interface/notification_center_repository_interface.dart";

class FirebaseNotificationRepository
    implements NotificationRepositoryInterface {
  FirebaseNotificationRepository({
    FirebaseApp? firebaseApp,
    this.activeNotificationsCollection = "active_notifications",
    this.plannedNotificationsCollection = "planned_notifications",
  }) : firebaseApp = firebaseApp ?? Firebase.app();

  final FirebaseApp firebaseApp;
  final String activeNotificationsCollection;
  final String plannedNotificationsCollection;

  @override
  Future<NotificationModel> addNotification(
    String userId,
    NotificationModel notification,
    List<String> recipientIds,
  ) async {
    var newNotification = notification;

    for (var recipientId in recipientIds) {
      DocumentReference notifications;
      if (notification.scheduledFor != null &&
          notification.scheduledFor!.isAfter(DateTime.now())) {
        notifications = FirebaseFirestore.instanceFor(app: firebaseApp)
            .collection(plannedNotificationsCollection)
            .doc(recipientId)
            .collection(plannedNotificationsCollection)
            .doc(notification.id);
      } else {
        newNotification = notification.copyWith(
          id: "${notification.id}-${DateTime.now().millisecondsSinceEpoch}",
        );

        notifications = FirebaseFirestore.instanceFor(app: firebaseApp)
            .collection(activeNotificationsCollection)
            .doc(recipientId)
            .collection(activeNotificationsCollection)
            .doc(newNotification.id);
      }

      var currentDateTime = DateTime.now();
      newNotification.dateTimePushed = currentDateTime;
      var notificationMap = newNotification.toMap();
      await notifications.set(notificationMap);
    }

    return newNotification;
  }

  @override
  Future<void> deleteNotification(
    String userId,
    String id,
    bool planned,
  ) async {
    try {
      if (planned) {
        await FirebaseFirestore.instanceFor(app: firebaseApp)
            .collection(plannedNotificationsCollection)
            .doc(userId)
            .collection(plannedNotificationsCollection)
            .doc(id)
            .delete();
      } else {
        await FirebaseFirestore.instanceFor(app: firebaseApp)
            .collection(activeNotificationsCollection)
            .doc(userId)
            .collection(activeNotificationsCollection)
            .doc(id)
            .delete();
      }
    } catch (e) {
      throw Exception("Failed to delete notification: $e");
    }
  }

  @override
  Stream<NotificationModel?> getNotification(String userId, String id) {
    var notificationStream = FirebaseFirestore.instanceFor(app: firebaseApp)
        .collection(activeNotificationsCollection)
        .doc(userId)
        .collection(activeNotificationsCollection)
        .doc(id)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        if (snapshot.data() == null) {
          return null;
        }

        return NotificationModel.fromJson(snapshot.data()!);
      } else {
        return null;
      }
    });

    return notificationStream;
  }

  @override
  Stream<List<NotificationModel>> getNotifications(String userId) {
    var notificationsStream = FirebaseFirestore.instanceFor(app: firebaseApp)
        .collection(activeNotificationsCollection)
        .doc(userId)
        .collection(activeNotificationsCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromJson(doc.data()))
              .toList(),
        );

    return notificationsStream;
  }

  @override
  Future<NotificationModel> updateNotification(
    String userId,
    NotificationModel notification,
  ) async {
    await FirebaseFirestore.instanceFor(app: firebaseApp)
        .collection(activeNotificationsCollection)
        .doc(userId)
        .collection(activeNotificationsCollection)
        .doc(notification.id)
        .update(notification.toMap());

    return notification;
  }

  @override
  Stream<List<NotificationModel>> getPlannedNotifications(String userId) {
    var notificationsStream = FirebaseFirestore.instanceFor(app: firebaseApp)
        .collection(plannedNotificationsCollection)
        .doc(userId)
        .collection(plannedNotificationsCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromJson(doc.data()))
              .toList(),
        );

    return notificationsStream;
  }
}
