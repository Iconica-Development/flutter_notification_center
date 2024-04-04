import 'package:flutter/material.dart';
import 'package:flutter_animated_widgets/flutter_animated_widgets.dart';
import 'package:flutter_notification_center/flutter_notification_center.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({
    required this.config,
    this.onTap,
    super.key,
  });

  final NotificationConfig config;
  final VoidCallback? onTap;

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  var notificationAmount = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var amount = await widget.config.service.getActiveNotifications();

      setState(() {
        notificationAmount = amount.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onTap,
      icon: AnimatedNotificationBell(
        duration: const Duration(seconds: 1),
        notificationCount: notificationAmount,
        style: widget.config.style.bellStyle,
      ),
    );
  }
}
