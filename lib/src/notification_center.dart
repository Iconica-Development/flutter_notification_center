import "package:flutter/material.dart";
import "package:flutter_notification_center/flutter_notification_center.dart";
import "package:flutter_notification_center/src/notification_detail.dart";

/// Widget for displaying the notification center.
class NotificationCenter extends StatefulWidget {
  /// Constructs a new NotificationCenter instance.
  ///
  /// [config]: Configuration for the notification center.
  const NotificationCenter({
    required this.config,
    super.key,
  });

  /// Configuration for the notification center.
  final NotificationConfig config;

  @override
  NotificationCenterState createState() => NotificationCenterState();
}

/// State for the notification center.
class NotificationCenterState extends State<NotificationCenter> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    // ignore: discarded_futures
    _notificationsFuture = widget.config.service.getActiveNotifications();
    widget.config.service.addListener(_listener);
  }

  @override
  void dispose() {
    widget.config.service.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No unread notifications available."),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length * 2 -
                    1, // Double the itemCount to include dividers
                itemBuilder: (context, index) {
                  if (index.isOdd) {
                    // If index is odd, return a Divider with padding
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Divider(
                        color: Colors.grey, // Customize as needed
                        thickness: 1.0, // Customize thickness as needed
                      ),
                    );
                  }
                  var notification = snapshot.data![index ~/ 2];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: notification.isPinned
                        ? GestureDetector(
                            onTap: () async =>
                                _navigateToNotificationDetail(notification),
                            child: ListTile(
                              leading: Icon(
                                notification.icon,
                                color: widget.config.style.leadingIconColor,
                              ),
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notification.title,
                                      style: widget.config.style.titleTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.push_pin),
                                color: widget.config.style.trailingIconColor,
                                onPressed: () async =>
                                    _navigateToNotificationDetail(notification),
                              ),
                            ),
                          )
                        : Dismissible(
                            key: Key(notification.id),
                            onDismissed: (direction) async {
                              await widget.config.service
                                  .dismissActiveNotification(notification);
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Notification dismissed"),
                                ),
                              );
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
                                  _navigateToNotificationDetail(notification),
                              child: ListTile(
                                leading: Icon(
                                  Icons.notification_important,
                                  color: widget.config.style.leadingIconColor,
                                ),
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification.title,
                                        style:
                                            widget.config.style.titleTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: !notification.isRead
                                    ? Container(
                                        margin:
                                            const EdgeInsets.only(left: 4.0),
                                        width: 12.0,
                                        height: 12.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget.config.style
                                                  .isReadDotColor ??
                                              Colors.red,
                                        ),
                                      )
                                    : null,
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
          onPressed: _addNewNotification,
          child: const Icon(Icons.add),
        ),
      );

  Future<void> _navigateToNotificationDetail(
    NotificationModel notification,
  ) async {
    await widget.config.service.markNotificationAsRead(notification);
    await Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailPage(
          config: widget.config,
          notification: notification,
        ),
      ),
    );
  }

  Future<void> _addNewNotification() async {
    await widget.config.service.pushNotification(
      NotificationModel(
        id: UniqueKey().toString(),
        title: UniqueKey().toString(),
        icon: Icons.notifications_active,
        body: "This is a new notification",
      ),
    );
  }
}
