import 'package:flutter_notification_center/src/models/notification.dart';

abstract class NotificationService {
  List<NotificationModel> listOfActiveNotifications;
  List<NotificationModel> listOfPlannedNotifications;

  NotificationService(
      {this.listOfActiveNotifications = const [],
      this.listOfPlannedNotifications = const []});

  Future pushNotification(NotificationModel notification);

  Future<List<NotificationModel>> getActiveNotifications();

  Future createScheduledNotification(NotificationModel notification);

  Future createRecurringNotification(NotificationModel notification);

  Future deleteScheduledNotification(NotificationModel notificationId);

  Future dismissActiveNotification(NotificationModel notificationId);

  Future checkForScheduledNotifications();
}
