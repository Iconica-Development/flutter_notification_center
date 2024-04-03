import 'package:flutter_notification_center/src/models/notification.dart';

class NotificationService {
  List<NotificationModel> listOfNotifications;

  NotificationService({this.listOfNotifications = const []});

  void addNotification(NotificationModel notification) {
    listOfNotifications.add(notification);
  }

  List<NotificationModel> getNotifications() {
    return listOfNotifications;
  }
}
