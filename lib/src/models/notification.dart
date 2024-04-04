enum OcurringInterval {
  daily,
  weekly,
  monthly,
  debug
}

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.dateTimePushed,
    this.scheduledFor,
    this.recurring = false,
    this.occuringInterval,
  });

  int id;
  String title;
  String body;
  DateTime? dateTimePushed;
  DateTime? scheduledFor;
  bool recurring;
  OcurringInterval? occuringInterval;

  // Override toString() to provide custom string representation
  @override
  String toString() {
    return 'NotificationModel{id: $id, title: $title, body: $body, dateTimePushed: $dateTimePushed, scheduledFor: $scheduledFor, recurring: $recurring, occuringInterval: $occuringInterval}';
  }
}
