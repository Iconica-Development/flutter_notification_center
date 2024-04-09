// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_notification_center/src/models/notification.dart';
// import 'package:flutter_notification_center/src/services/notification_service.dart';

// class LocalNotificationService implements NotificationService {
//   @override
//   List<NotificationModel> listOfActiveNotifications;
//   @override
//   List<NotificationModel> listOfPlannedNotifications;

//   late Timer _timer;

//   LocalNotificationService(
//       {this.listOfActiveNotifications = const [],
//       this.listOfPlannedNotifications = const []}) {
//     _startTimer();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       debugPrint('Checking for scheduled notifications...');
//       checkForScheduledNotifications();
//     });
//   }

//   void _cancelTimer() {
//     _timer.cancel();
//   }

//   @override
//   Future pushNotification(NotificationModel notification) async {
//     notification.dateTimePushed = DateTime.now();
//     listOfActiveNotifications.add(notification);
//   }

//   @override
//   Future<List<NotificationModel>> getActiveNotifications() async {
//     print('Getting all active notifications...');
//     return listOfActiveNotifications;
//   }

//   @override
//   Future createScheduledNotification(NotificationModel notification) async {
//     listOfPlannedNotifications = [...listOfPlannedNotifications, notification];
//     print('Creating scheduled notification: $notification');
//   }

//   @override
//   Future createRecurringNotification(NotificationModel notification) async {
//     // If recurring, update the scheduled date for the next occurrence
//     notification.title = notification.id.toString();
//     await pushNotification(notification);
//     if (notification.recurring) {
//       switch (notification.occuringInterval) {
//         case OcurringInterval.daily:
//           notification.scheduledFor =
//               notification.scheduledFor!.add(const Duration(days: 1));
//           break;
//         case OcurringInterval.weekly:
//           notification.scheduledFor =
//               notification.scheduledFor!.add(const Duration(days: 7));
//           break;
//         case OcurringInterval.monthly:
//           // Add logic for monthly recurrence, e.g., adding 1 month to the scheduled date
//           break;
//         case OcurringInterval.debug:
//           notification.scheduledFor =
//               notification.scheduledFor!.add(const Duration(seconds: 5));
//           break;
//         case null:
//         // TODO: Handle this case.
//       }

//       // Create the next recurring notification
//       listOfPlannedNotifications = [
//         ...listOfPlannedNotifications,
//         notification
//       ];
//       print('Created recurring notification for: ${notification.scheduledFor}');
//     }
//   }

//   @override
//   Future deleteScheduledNotification(NotificationModel notification) async {
//     listOfPlannedNotifications =
//         listOfPlannedNotifications.where((n) => n != notification).toList();
//     print('Notification deleted: $notification');
//   }

//   @override
//   Future dismissActiveNotification(NotificationModel notification) async {
//     String id = notification.id;
//     listOfActiveNotifications.removeWhere((n) => n.id == id);
//     print('Notification with ID $id dismissed');
//     print('List of active notifications: $listOfActiveNotifications');
//   }

//   @override
//   Future<void> checkForScheduledNotifications() async {
//     DateTime currentTime = DateTime.now();

//     if (listOfPlannedNotifications.isEmpty) {
//       print('There are no scheduled notifications to be pushed');
//       return;
//     }

//     for (NotificationModel notification
//         in listOfPlannedNotifications.toList()) {
//       // Check if scheduledFor is not null
//       if (notification.scheduledFor != null) {
//         // Check if the scheduled date and time is before or equal to the current date and time
//         if (notification.scheduledFor!.isBefore(currentTime) ||
//             notification.scheduledFor!.isAtSameMomentAs(currentTime)) {
//           // Push the notification if it's due
//           await pushNotification(notification);
//           print('Scheduled notification pushed: $notification');

//           // If recurring, update the scheduled date for the next occurrence
//           if (notification.recurring) {
//             // Increment the ID for recurring notifications
//             notification.id += 1;
//             notification.title = notification.id.toString();
//             print('New RECURRING ID IS: ${notification.id}');

//             // Create the next recurring notification
//             await createRecurringNotification(notification);
//           } else {
//             // Delete the notification if not recurring
//             print('Non-recurring notification removed: $notification');
//           }
//         }
//       }
//     }
//   }
// }
