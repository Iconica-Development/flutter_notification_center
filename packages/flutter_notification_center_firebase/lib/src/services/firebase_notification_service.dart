import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_center/flutter_notification_center.dart';
import '../config/firebase_collections.dart';

class FirebaseNotificationService
    with ChangeNotifier
    implements NotificationService {
  @override
  List<NotificationModel> listOfActiveNotifications;
  @override
  List<NotificationModel> listOfPlannedNotifications;

  // ignore: unused_field
  late Timer _timer;

  FirebaseNotificationService(
      {this.listOfActiveNotifications = const [],
      this.listOfPlannedNotifications = const []}) {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      debugPrint('Checking for scheduled notifications');
      checkForScheduledNotifications();
    });
  }

  @override
  Future<void> pushNotification(NotificationModel notification) async {
    try {
      CollectionReference notifications = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.activeNotifications);

      DateTime currentDateTime = DateTime.now();
      notification.dateTimePushed = currentDateTime;
      Map<String, dynamic> notificationMap = notification.toMap();
      await notifications.doc(notification.id).set(notificationMap);

      listOfActiveNotifications.add(notification);
      notifyListeners();
    } catch (e) {
      debugPrint('Error creating document: $e');
    }
  }

  @override
  Future<List<NotificationModel>> getActiveNotifications() async {
    try {
      CollectionReference activeNotificationsCollection = FirebaseFirestore
          .instance
          .collection(FirebaseCollectionNames.activeNotifications);

      QuerySnapshot querySnapshot = await activeNotificationsCollection.get();

      List<NotificationModel> activeNotifications =
          querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return NotificationModel.fromJson(data);
      }).toList();

      listOfActiveNotifications = activeNotifications;
      notifyListeners();
      return listOfActiveNotifications;
    } catch (e) {
      debugPrint('Error getting active notifications: $e');
      return [];
    }
  }

  @override
  Future<void> createRecurringNotification(
      NotificationModel notification) async {
    if (notification.recurring) {
      switch (notification.occuringInterval) {
        case OcurringInterval.daily:
          notification.scheduledFor =
              DateTime.now().add(const Duration(days: 1));
          break;
        case OcurringInterval.weekly:
          notification.scheduledFor =
              DateTime.now().add(const Duration(days: 7));
          break;
        case OcurringInterval.monthly:
          notification.scheduledFor =
              DateTime.now().add(const Duration(days: 30));
          break;
        case OcurringInterval.debug:
          notification.scheduledFor =
              DateTime.now().add(const Duration(seconds: 10));
          break;
        case null:
      }
      createScheduledNotification(notification);
    }
  }

  @override
  Future<void> createScheduledNotification(
      NotificationModel notification) async {
    try {
      CollectionReference plannedNotifications = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.plannedNotifications);
      Map<String, dynamic> notificationMap = notification.toMap();
      await plannedNotifications.doc(notification.id).set(notificationMap);
    } catch (e) {
      debugPrint('Error creating document: $e');
    }
  }

  @override
  Future<void> deleteScheduledNotification(
      NotificationModel notificationModel) async {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.plannedNotifications)
          .doc(notificationModel.id);
      await documentReference.delete();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.plannedNotifications)
          .get();

      if (querySnapshot.docs.isEmpty) {
        debugPrint('The collection is now empty');
      } else {
        debugPrint(
            'Deleted planned notification with title: ${notificationModel.title}');
      }
    } catch (e) {
      debugPrint('Error deleting document: $e');
    }
  }

  @override
  Future<void> dismissActiveNotification(
      NotificationModel notificationModel) async {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.activeNotifications)
          .doc(notificationModel.id);
      await documentReference.delete();
      listOfActiveNotifications
          .removeAt(listOfActiveNotifications.indexOf(notificationModel));
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting document: $e');
    }
  }

  @override
  Future<void> markNotificationAsRead(
      NotificationModel notificationModel) async {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.activeNotifications)
          .doc(notificationModel.id);
      await documentReference.update({'isRead': true});
      notificationModel.isRead = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating document: $e');
    }
  }

  @override
  Future<void> checkForScheduledNotifications() async {
    DateTime currentTime = DateTime.now();
    try {
      CollectionReference plannedNotificationsCollection = FirebaseFirestore
          .instance
          .collection(FirebaseCollectionNames.plannedNotifications);

      QuerySnapshot querySnapshot = await plannedNotificationsCollection.get();

      if (querySnapshot.docs.isEmpty) {
        debugPrint('No scheduled notifications to be pushed');
        return;
      }

      List<NotificationModel> plannedNotifications =
          querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return NotificationModel.fromJson(data);
      }).toList();

      for (NotificationModel notification in plannedNotifications) {
        if (notification.scheduledFor!.isBefore(currentTime) ||
            notification.scheduledFor!.isAtSameMomentAs(currentTime)) {
          await pushNotification(notification);
          await deleteScheduledNotification(notification);

          //Plan new recurring notification instance
          if (notification.recurring) {
            NotificationModel newNotification = NotificationModel(
              id: UniqueKey().toString(),
              title: notification.title,
              body: notification.body,
              recurring: true,
              occuringInterval: notification.occuringInterval,
              scheduledFor: DateTime.now().add(const Duration(seconds: 10)),
            );
            await createScheduledNotification(newNotification);
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting planned notifications: $e');
      return;
    }
  }
}
