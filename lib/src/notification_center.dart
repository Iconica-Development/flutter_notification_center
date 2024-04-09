import 'package:flutter/material.dart';
import 'package:flutter_notification_center/flutter_notification_center.dart';
import 'package:flutter_notification_center/src/notification_detail.dart';
import 'package:intl/intl.dart';

/// Widget for displaying the notification center.
class NotificationCenter extends StatefulWidget {
  /// Configuration for the notification center.
  final NotificationConfig config;

  /// Constructs a new NotificationCenter instance.
  ///
  /// [config]: Configuration for the notification center.
  const NotificationCenter({
    required this.config,
    Key? key,
  }) : super(key: key);

  @override
  _NotificationCenterState createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = widget.config.service.getActiveNotifications();
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No unread notifications available.'));
          } else {
            final unreadNotifications = snapshot.data!.toList();

            return ListView.builder(
              itemCount: unreadNotifications.length,
              itemBuilder: (context, index) {
                final notification = unreadNotifications[index];
                final formattedDateTime = notification.dateTimePushed != null
                    ? DateFormat('yyyy-MM-dd HH:mm')
                        .format(notification.dateTimePushed!)
                    : 'Pending';
                return GestureDetector(
                  onTap: () {
                    widget.config.service.markNotificationAsRead(notification);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationDetailPage(
                          config: widget.config,
                          notification: notification,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    color: notification.isRead
                        ? Colors.grey.shade300
                        : Colors.transparent,
                    child: ListTile(
                      title: Column(
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (notification.isPinned)
                            IconButton(
                              icon: const Icon(Icons.push_pin),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationDetailPage(
                                      config: widget.config,
                                      notification: notification,
                                    ),
                                  ),
                                );
                              },
                            ),
                          if (!notification.isPinned)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  widget.config.service
                                      .dismissActiveNotification(notification);
                                  setState(() {
                                    _notificationsFuture = widget.config.service
                                        .getActiveNotifications();
                                  });
                                  debugPrint(
                                      'Notification dismissed: $notification');
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          widget.config.service.createScheduledNotification(
            NotificationModel(
              id: UniqueKey().toString(),
              title: UniqueKey().toString(),
              body: 'This is a new notification',
              scheduledFor: DateTime.now().add(const Duration(seconds: 10)),
            ),
          );
          setState(() {
            _notificationsFuture =
                widget.config.service.getActiveNotifications();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
