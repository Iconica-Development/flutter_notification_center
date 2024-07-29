import "package:flutter/material.dart";
import "package:flutter_notification_center/flutter_notification_center.dart";
import "package:flutter_svg/svg.dart";
import "package:intl/intl.dart";

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
    widget.config.service.getActiveAmountStream().listen((amount) async {
      _notificationsFuture = widget.config.service.getActiveNotifications();
    });
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
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          widget.config.translations.appBarTitle,
          style: theme.textTheme.headlineLarge,
        ),
        centerTitle: true,
        iconTheme: theme.appBarTheme.iconTheme ??
            const IconThemeData(color: Colors.white),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            debugPrint("Error: ${snapshot.error}");
            return Center(child: Text(widget.config.translations.errorMessage));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return widget.config.emptyNotificationsBuilder?.call() ??
                Center(
                  child: Text(
                    widget.config.translations.noNotifications,
                    style: theme.textTheme.bodyMedium,
                  ),
                );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var notification = snapshot.data![index];
                return notification.isPinned
                    ? GestureDetector(
                        onTap: () async => _navigateToNotificationDetail(
                          context,
                          notification,
                          widget.config.service,
                          widget.config.translations,
                        ),
                        child: Dismissible(
                          key: Key("${notification.id}_pinned"),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              await unPinNotification(
                                widget.config.service,
                                notification,
                                widget.config.translations,
                                context,
                              );
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              await unPinNotification(
                                widget.config.service,
                                notification,
                                widget.config.translations,
                                context,
                              );
                            }
                          },
                          background: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF88CB33),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomLeft: Radius.circular(6),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: SvgPicture.asset(
                                "assets/unpin_icon.svg",
                                package: "flutter_notification_center",
                                color: Colors.white,
                                height: 24,
                              ),
                            ),
                          ),
                          secondaryBackground: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF88CB33),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                            ),
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: SvgPicture.asset(
                                "assets/unpin_icon.svg",
                                package: "flutter_notification_center",
                                color: Colors.white,
                                height: 24,
                              ),
                            ),
                          ),
                          child: _notificationItem(
                            context,
                            notification,
                            widget.config,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async => _navigateToNotificationDetail(
                          context,
                          notification,
                          widget.config.service,
                          widget.config.translations,
                        ),
                        child: Dismissible(
                          key: Key(notification.id),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              await dismissNotification(
                                widget.config.service,
                                notification,
                                widget.config.translations,
                                context,
                              );
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              await pinNotification(
                                widget.config.service,
                                notification,
                                widget.config.translations,
                                context,
                              );
                            }
                          },
                          background: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF88CB33),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomLeft: Radius.circular(6),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Transform.rotate(
                                angle: 0.5,
                                child: const Icon(
                                  Icons.push_pin_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          secondaryBackground: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6161),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                ),
                              ),
                              alignment: Alignment.centerRight,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          child: _notificationItem(
                            context,
                            notification,
                            widget.config,
                          ),
                        ),
                      );
              },
            );
          }
        },
      ),
    );
  }
}

Widget _notificationItem(
  BuildContext context,
  NotificationModel notification,
  NotificationConfig config,
) {
  var theme = Theme.of(context);
  var dateTimePushed =
      DateFormat("dd/MM/yyyy 'at' HH:mm").format(notification.dateTimePushed!);
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (!notification.isPinned) ...[
                  if (!notification.isRead) ...[
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.circle_rounded,
                      color: Colors.black,
                      size: 8,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ] else ...[
                  const SizedBox(
                    width: 8,
                  ),
                  Transform.rotate(
                    angle: 0.5,
                    child: Icon(
                      Icons.push_pin_outlined,
                      color: config.pinnedIconColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
                Text(
                  notification.title,
                  style: notification.isRead && !notification.isPinned
                      ? theme.textTheme.bodyMedium
                      : theme.textTheme.titleMedium,
                ),
              ],
            ),
            Text(
              dateTimePushed,
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _navigateToNotificationDetail(
  BuildContext context,
  NotificationModel notification,
  NotificationService notificationService,
  NotificationTranslations notificationTranslations,
) async {
  if (context.mounted) {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailPage(
          translations: notificationTranslations,
          notification: notification,
        ),
      ),
    );
  }
  await markNotificationAsRead(notificationService, notification);
}

Future<void> dismissNotification(
  NotificationService notificationService,
  NotificationModel notification,
  NotificationTranslations notificationTranslations,
  BuildContext context,
) async {
  await notificationService.dismissActiveNotification(notification);
  if (context.mounted) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(notificationTranslations.notificationDismissed),
      ),
    );
  }
}

Future<void> pinNotification(
  NotificationService notificationService,
  NotificationModel notification,
  NotificationTranslations notificationTranslations,
  BuildContext context,
) async {
  await notificationService.pinActiveNotification(notification);
  if (context.mounted) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(notificationTranslations.notificationPinned),
      ),
    );
  }
}

Future<void> unPinNotification(
  NotificationService notificationService,
  NotificationModel notification,
  NotificationTranslations notificationTranslations,
  BuildContext context,
) async {
  await notificationService.unPinActiveNotification(notification);
  if (context.mounted) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(notificationTranslations.notificationUnpinned),
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
