/// Enum representing the interval at which notifications occur.
enum OcurringInterval {
  /// Notifications occur daily.
  daily,

  /// Notifications occur weekly.
  weekly,

  /// Notifications occur monthly.
  monthly,

  /// Debug option for testing purposes.
  debug,
}

/// Model class representing a notification.
class NotificationModel {
  /// Unique identifier for the notification.
  final String id;

  /// Title of the notification.
  final String title;

  /// Body content of the notification.
  final String body;

  /// Date and time when the notification was pushed.
  DateTime? dateTimePushed;

  /// Date and time when the notification is scheduled for.
  DateTime? scheduledFor;

  /// Indicates if the notification is recurring.
  final bool recurring;

  /// Interval at which the notification occurs, applicable if it's recurring.
  final OcurringInterval? occuringInterval;

  /// Indicates if the notification is pinned.
  final bool isPinned;

  /// Indicates if the notification has been read.
  final bool isRead;

  /// Constructs a new NotificationModel instance.
  ///
  /// [id]: Unique identifier for the notification.
  /// [title]: Title of the notification.
  /// [body]: Body content of the notification.
  /// [dateTimePushed]: Date and time when the notification was pushed.
  /// [scheduledFor]: Date and time when the notification is scheduled for.
  /// [recurring]: Indicates if the notification is recurring.
  /// [occuringInterval]: Interval at which the notification occurs, applicable if it's recurring.
  /// [isPinned]: Indicates if the notification is pinned.
  /// [isRead]: Indicates if the notification has been read.
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.dateTimePushed,
    this.scheduledFor,
    this.recurring = false,
    this.occuringInterval,
    this.isPinned = false,
    this.isRead = false,
  });

  /// Override toString() to provide custom string representation
  @override
  String toString() {
    return 'NotificationModel{id: $id, title: $title, body: $body, dateTimePushed: $dateTimePushed, scheduledFor: $scheduledFor, recurring: $recurring, occuringInterval: $occuringInterval, isPinned: $isPinned}';
  }

  /// Method to create a NotificationModel object from JSON data
  static NotificationModel fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      dateTimePushed: json['dateTimePushed'] != null
          ? DateTime.parse(json['dateTimePushed'])
          : null,
      scheduledFor: json['scheduledFor'] != null
          ? DateTime.parse(json['scheduledFor'])
          : null,
      recurring: json['recurring'] ?? false,
      occuringInterval: json['occuringInterval'] != null
          ? OcurringInterval.values[json['occuringInterval']]
          : null,
      isPinned: json['isPinned'] ?? false,
      isRead: json['isRead'] ?? false,
    );
  }

  /// Convert the NotificationModel object to a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'dateTimePushed': dateTimePushed?.toIso8601String(),
      'scheduledFor': scheduledFor?.toIso8601String(),
      'recurring': recurring,
      'occuringInterval': occuringInterval?.index,
      'isPinned': isPinned,
      'isRead': isRead,
    };
  }

  /// Create a copy of the NotificationModel with some fields replaced.
  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? dateTimePushed,
    DateTime? scheduledFor,
    bool? recurring,
    OcurringInterval? occuringInterval,
    bool? isPinned,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      dateTimePushed: dateTimePushed ?? this.dateTimePushed,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      recurring: recurring ?? this.recurring,
      occuringInterval: occuringInterval ?? this.occuringInterval,
      isPinned: isPinned ?? this.isPinned,
      isRead: isRead ?? this.isRead,
    );
  }
}
