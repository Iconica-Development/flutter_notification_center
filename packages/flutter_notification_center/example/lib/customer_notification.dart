import 'package:flutter/material.dart';
import 'package:flutter_notification_center/flutter_notification_center.dart';
import 'package:flutter_notification_center_firebase/flutter_notification_center_firebase.dart';

class CustomNotificationWidget extends StatelessWidget {
  final NotificationModel notification;
  final NotificationStyle style;
  final FirebaseNotificationService notificationService;
  final NotificationTranslations notificationTranslations;
  final BuildContext context;

  const CustomNotificationWidget({
    required this.notification,
    required this.style,
    required this.notificationTranslations,
    required this.notificationService,
    required this.context,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return notification.isPinned
        //Pinned notification
        ? GestureDetector(
            onTap: () async =>
                _navigateToNotificationDetail(context, notification),
            child: ListTile(
              leading: style.showNotificationIcon != null
                  ? Icon(
                      notification.icon,
                      color: style.leadingIconColor,
                    )
                  : null,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: style.titleTextStyle,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.push_pin),
                color: style.pinnedIconColor,
                onPressed: () async =>
                    _navigateToNotificationDetail(context, notification),
                padding: const EdgeInsets.only(left: 60.0),
              ),
            ),
          )
        //Dismissable notification
        : Dismissible(
            key: Key(notification.id),
            onDismissed: (direction) async {
              await dismissNotification(notificationService, notification);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: GestureDetector(
              onTap: () async =>
                  _navigateToNotificationDetail(context, notification),
              child: ListTile(
                leading: Icon(
                  notification.icon,
                  color: style.leadingIconColor,
                ),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: style.titleTextStyle,
                      ),
                    ),
                  ],
                ),
                trailing: !notification.isRead
                    ? Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        width: 12.0,
                        height: 12.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: style.isReadDotColor ?? Colors.red,
                        ),
                      )
                    : null,
              ),
            ),
          );
  }

  Future<void> _navigateToNotificationDetail(
    BuildContext context,
    NotificationModel notification,
  ) async {
    await markNotificationAsRead(notificationService, notification);
    if (context.mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationDetailPage(
            translations: notificationTranslations,
            notification: notification,
            notificationStyle: style,
          ),
        ),
      );
    }
  }

  Future<void> dismissNotification(
    FirebaseNotificationService notificationService,
    NotificationModel notification,
  ) async {
    await notificationService.dismissActiveNotification(notification);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Notification dismissed"),
        ),
      );
    }
  }

  Future<void> markNotificationAsRead(
    FirebaseNotificationService notificationService,
    NotificationModel notification,
  ) async {
    await notificationService.markNotificationAsRead(notification);
  }
}
