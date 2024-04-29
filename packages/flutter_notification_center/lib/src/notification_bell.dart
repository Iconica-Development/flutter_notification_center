import "package:flutter/material.dart";
import "../flutter_notification_center.dart";

/// A bell icon widget that displays the number of active notifications.
///
/// This widget displays a bell icon with an animation indicating the number
/// of active notifications. It interacts with the notification service provided
/// in the [config] to fetch the active notifications and update its display
/// accordingly.
class NotificationBell extends StatefulWidget {
  /// Constructs a NotificationBell widget.
  ///
  /// [config]: The notification configuration used to interact with the
  /// notification service.
  /// [onTap]: Callback function to be invoked when the bell icon is tapped.
  const NotificationBell({
    required this.config,
    this.onTap,
    super.key,
  });

  /// The notification configuration used to interact with
  ///  the notification service.
  final NotificationConfig config;

  /// Callback function to be invoked when the bell icon is tapped.
  final VoidCallback? onTap;

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  /// The number of active notifications.
  int notificationAmount = 0;

  @override
  void initState() {
    super.initState();

    // Fetch active notifications and update the notification count
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var amount = await widget.config.service.getActiveNotifications();

      setState(() {
        notificationAmount = amount.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: widget.onTap,
        icon: AnimatedNotificationBell(
          duration: const Duration(seconds: 1),
          notificationCount: notificationAmount,
          style: widget.config.bellStyle,
        ),
      );
}
