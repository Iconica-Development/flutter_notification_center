import 'package:flutter/material.dart';
import '../flutter_notification_center.dart';

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
                itemCount: snapshot.data!.length * 2 - 1,
                itemBuilder: (context, index) {
                  if (index.isOdd) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: widget.config.seperateNotificationsWithDivider
                          ? const Divider(
                              color: Colors.grey,
                              thickness: 1.0,
                            )
                          : Container(),
                    );
                  }
                  var notification = snapshot.data![index ~/ 2];
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: widget.config.notificationWidgetBuilder != null
                          ? widget.config.notificationWidgetBuilder!(
                              notification, context)
                          : notification.isPinned
                              //Pinned notification
                              ? GestureDetector(
                                  onTap: () async =>
                                      _navigateToNotificationDetail(
                                          context,
                                          notification,
                                          widget.config.service,
                                          widget.config.translations,
                                          const NotificationStyle()),
                                  child: ListTile(
                                    leading: Icon(
                                      notification.icon,
                                      color: Colors.grey,
                                    ),
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notification.title,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.push_pin),
                                      color: Colors.grey,
                                      onPressed: () async =>
                                          _navigateToNotificationDetail(
                                              context,
                                              notification,
                                              widget.config.service,
                                              widget.config.translations,
                                              const NotificationStyle()),
                                      padding:
                                          const EdgeInsets.only(left: 60.0),
                                    ),
                                  ),
                                )
                              //Dismissable notification
                              : Dismissible(
                                  key: Key(notification.id),
                                  onDismissed: (direction) async {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      await dismissNotification(
                                          widget.config.service,
                                          notification,
                                          context);
                                    } else if (direction ==
                                        DismissDirection.startToEnd) {
                                      await pinNotification(
                                          widget.config.service,
                                          notification,
                                          context);
                                    }
                                  },
                                  background: Container(
                                    color:
                                        const Color.fromRGBO(59, 213, 111, 1),
                                    alignment: Alignment.centerLeft,
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 16.0),
                                      child: Icon(
                                        Icons.push_pin,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  secondaryBackground: Container(
                                    color:
                                        const Color.fromRGBO(255, 131, 131, 1),
                                    alignment: Alignment.centerRight,
                                    child: const Padding(
                                      padding: EdgeInsets.only(right: 16.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () async =>
                                        _navigateToNotificationDetail(
                                            context,
                                            notification,
                                            widget.config.service,
                                            widget.config.translations,
                                            const NotificationStyle()),
                                    child: ListTile(
                                      leading: Icon(
                                        notification.icon,
                                        color: Colors.grey,
                                      ),
                                      title: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              notification.title,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: !notification.isRead
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  right: 8.0),
                                              width: 12.0,
                                              height: 12.0,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                ));
                },
              );
            }
          },
        ),
      );
}

Future<void> _navigateToNotificationDetail(
  BuildContext context,
  NotificationModel notification,
  NotificationService notificationService,
  NotificationTranslations notificationTranslations,
  NotificationStyle style,
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
  NotificationService notificationService,
  NotificationModel notification,
  BuildContext context,
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

Future<void> pinNotification(
  NotificationService notificationService,
  NotificationModel notification,
  BuildContext context,
) async {
  await notificationService.pinActiveNotification(notification);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Notification pinned"),
      ),
    );
  }
}

Future<void> markNotificationAsRead(
  NotificationService notificationService,
  NotificationModel notification,
) async {
  await notificationService.markNotificationAsRead(notification);
}
