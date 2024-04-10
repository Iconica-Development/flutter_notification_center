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
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final notification = snapshot.data![index];
                  final formattedDateTime = notification.dateTimePushed != null
                      ? DateFormat('yyyy-MM-dd HH:mm')
                          .format(notification.dateTimePushed!)
                      : 'Pending';
                  return notification.isPinned
                      ? GestureDetector(
                          onTap: () =>
                              _navigateToNotificationDetail(notification),
                          child: Container(
                            child: ListTile(
                              leading: Icon(notification.icon,
                                  color: widget.config.style.leadingIconColor),
                              title: _buildNotificationTitle(notification.title,
                                  widget.config.style.titleTextStyle),
                              subtitle: _buildNotificationSubtitle(
                                  notification.body,
                                  formattedDateTime,
                                  notification.isRead),
                              trailing: IconButton(
                                icon: const Icon(Icons.push_pin),
                                color: widget.config.style.trailingIconColor,
                                onPressed: () =>
                                    _navigateToNotificationDetail(notification),
                              ),
                            ),
                          ),
                        )
                      : Dismissible(
                          key: Key(notification.id),
                          onDismissed: (direction) {
                            setState(() {
                              widget.config.service
                                  .dismissActiveNotification(notification);
                              _refreshNotifications();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Notification dismissed'),
                              ),
                            );
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () =>
                                _navigateToNotificationDetail(notification),
                            child: Container(
                              child: ListTile(
                                leading: Icon(
                                  Icons.notification_important,
                                  color: widget.config.style.leadingIconColor,
                                ),
                                title: _buildNotificationTitle(
                                    notification.title,
                                    widget.config.style.titleTextStyle),
                                subtitle: _buildNotificationSubtitle(
                                    notification.body,
                                    formattedDateTime,
                                    notification.isRead),
                              ),
                            ),
                          ),
                        );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNotification,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotificationTitle(String title, TextStyle? textStyle) {
    return Text(
      title,
      style: textStyle ?? const TextStyle(),
    );
  }

  Widget _buildNotificationSubtitle(
      String body, String formattedDateTime, bool isRead) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                body,
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
        ),
        if (!isRead)
          Container(
            margin: const EdgeInsets.only(left: 4.0),
            width: 12.0,
            height: 12.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  void _refreshNotifications() {
    setState(() {
      _notificationsFuture = widget.config.service.getActiveNotifications();
    });
  }

  void _navigateToNotificationDetail(NotificationModel notification) {
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
  }

  void _addNewNotification() {
    widget.config.service.pushNotification(
      NotificationModel(
        id: UniqueKey().toString(),
        title: UniqueKey().toString(),
        isPinned: true,
        icon: Icons.notifications_active,
        body: 'This is a new notification',
      ),
    );
    _refreshNotifications();
  }
}
