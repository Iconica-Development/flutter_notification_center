import "package:flutter/material.dart";
import "package:flutter_animated_widgets/flutter_animated_widgets.dart";
import "package:notification_center_repository_interface/notification_center_repository_interface.dart";

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
    required this.service,
    this.animatedIconStyle,
    this.onTap,
    super.key,
  });

  /// The notification configuration used to interact with
  ///  the notification service.
  final NotificationConfig config;

  /// The notification service used to fetch active notifications.
  final NotificationService service;

  /// The style of the animated bell icon.
  final AnimatedNotificationBellStyle? animatedIconStyle;

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
    widget.service.getActiveAmountStream().listen((amount) {
      setState(() {
        notificationAmount = amount;
      });
    });
  }

  @override
  Widget build(BuildContext context) => IconButton(
        padding: EdgeInsets.zero,
        onPressed: widget.onTap,
        icon: AnimatedNotificationBell(
          duration: const Duration(seconds: 1),
          notificationCount: notificationAmount,
          style:
              widget.animatedIconStyle ?? const AnimatedNotificationBellStyle(),
        ),
      );
}
