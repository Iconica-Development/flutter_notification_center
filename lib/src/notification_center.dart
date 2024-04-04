import 'package:flutter/material.dart';
import 'package:flutter_notification_center/src/models/notification.dart';
import 'package:flutter_notification_center/src/models/notification_theme.dart';
import 'package:flutter_notification_center/src/models/notification_translation.dart';
import 'package:flutter_notification_center/src/services/notification_service.dart';
import 'package:intl/intl.dart';

class NotificationCenter extends StatefulWidget {
  final NotificationService notificationCenterService;
  final NotificationStyle? notificationTheme;
  final NotificationTranslations translations;

  const NotificationCenter({
    super.key,
    required this.notificationCenterService,
    this.notificationTheme,
    this.translations = const NotificationTranslations(),
  });

  @override
  _NotificationCenterState createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
  late List<NotificationModel> listOfNotifications;

  @override
  void initState() {
    super.initState();
    listOfNotifications = widget.notificationCenterService.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final unreadNotifications = listOfNotifications
        .where((notification) => !notification.isRead)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.translations.appBarTitle,
          style: widget.notificationTheme?.appTitleTextStyle,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: unreadNotifications.isEmpty
          ? widget.notificationTheme?.emptyNotificationsBuilder?.call() ??
              Center(
                child: Text(widget.translations.appBarTitle),
              )
          : ListView.builder(
              itemCount: unreadNotifications.length,
              itemBuilder: (context, index) {
                final notification = unreadNotifications[index];
                final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm')
                    .format(notification.dateTime);
                return Container(
                  decoration: widget.notificationTheme?.tileDecoration,
                  child: ListTile(
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: widget.notificationTheme?.titleTextStyle ??
                              const TextStyle(),
                        ),
                        Text(
                          notification.body,
                          style: widget.notificationTheme?.subtitleTextStyle ??
                              const TextStyle(),
                        ),
                        Text(
                          formattedDateTime,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          notification.isRead = true;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
