import "package:flutter/material.dart";
import "package:flutter_animated_widgets/flutter_animated_widgets.dart";
import "package:flutter_notification_center/src/notification_center.dart";
import "package:flutter_notification_center/src/screens/notification_bell.dart";
import "package:notification_center_repository_interface/notification_center_repository_interface.dart";

/// A widget representing a notification bell.
class NotificationBellWidgetStory extends StatefulWidget {
  /// Creates a new [NotificationBellWidgetStory] instance.
  ///
  /// The [config] parameter specifies the notification configuration.
  const NotificationBellWidgetStory({
    required this.userId,
    this.config,
    this.service,
    this.animatedIconStyle,
    super.key,
  });

  /// The user ID.
  final String userId;

  /// The notification configuration.
  final NotificationConfig? config;

  /// The notification service.
  final NotificationService? service;

  final AnimatedNotificationBellStyle? animatedIconStyle;

  @override
  State<NotificationBellWidgetStory> createState() =>
      _NotificationBellWidgetStoryState();
}

class _NotificationBellWidgetStoryState
    extends State<NotificationBellWidgetStory> {
  late NotificationConfig config;
  late NotificationService service;

  @override
  void initState() {
    config = widget.config ?? const NotificationConfig();
    service = widget.service ??
        NotificationService(
          userId: widget.userId,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => NotificationBell(
        config: config,
        service: service,
        animatedIconStyle: widget.animatedIconStyle,
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NotificationCenter(
                config: config,
                service: service,
              ),
            ),
          );
        },
      );
}
