enum ScheduleType {
  minute,
  daily,
  weekly,
  monthly,
}

class NotificationModel {
  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    required this.dateTime,
    required this.isRead,
    this.isScheduled = false,
    this.scheduledFor,
  });

  int? id;
  String title;
  String body;
  DateTime dateTime;
  bool isRead;
  bool isScheduled;
  ScheduleType? scheduledFor;
}
