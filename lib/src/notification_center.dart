import 'package:flutter/material.dart';
import 'package:flutter_notification_center/flutter_notification_center.dart';
import 'package:intl/intl.dart';

class NotificationCenter extends StatefulWidget {
  final NotificationConfig config;

  const NotificationCenter({
    super.key,
    required this.config,
  });

  @override
  _NotificationCenterState createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
  late List<NotificationModel> listOfNotifications;

  @override
  void initState() {
    super.initState();
    listOfNotifications = widget.config.service.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final unreadNotifications = listOfNotifications
        .where((notification) => !notification.isRead)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.config.translations.appBarTitle,
          style: widget.config.style.appTitleTextStyle,
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
          ? widget.config.style.emptyNotificationsBuilder?.call() ??
              Center(
                child: Text(widget.config.translations.appBarTitle),
              )
          : ListView.builder(
              itemCount: unreadNotifications.length,
              itemBuilder: (context, index) {
                final notification = unreadNotifications[index];
                final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm')
                    .format(notification.dateTime);
                return Container(
                  decoration: widget.config.style.tileDecoration,
                  child: ListTile(
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: widget.config.style.titleTextStyle ??
                              const TextStyle(),
                        ),
                        Text(
                          notification.body,
                          style: widget.config.style.subtitleTextStyle ??
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
