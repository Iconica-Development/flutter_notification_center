import 'package:flutter_notification_center/flutter_notification_center.dart';
import 'package:flutter_notification_center/src/models/notification_translation.dart';

class NotificationConfig {
  final NotificationService service;
  final NotificationStyle style;
  final NotificationTranslations translations;

  const NotificationConfig({
    required this.service,
    this.style = const NotificationStyle(),
    this.translations = const NotificationTranslations(),
  });
}
