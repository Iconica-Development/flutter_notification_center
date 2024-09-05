import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_notification_center/flutter_notification_center.dart";

class FirebaseNotificationService
    with ChangeNotifier
    implements NotificationService {
  FirebaseNotificationService({
    required this.newNotificationCallback,
    this.firebaseApp,
    this.activeNotificationsCollection = "active_notifications",
    this.plannedNotificationsCollection = "planned_notifications",
    this.listOfActiveNotifications = const [],
    this.listOfPlannedNotifications = const [],
  }) {
    _firebaseApp = firebaseApp ?? Firebase.app();
    unawaited(_startTimer());
  }
  final Function(NotificationModel) newNotificationCallback;
  final FirebaseApp? firebaseApp;
  final String activeNotificationsCollection;
  final String plannedNotificationsCollection;
  late FirebaseApp _firebaseApp;

  @override
  List<NotificationModel> listOfActiveNotifications;
  @override
  List<NotificationModel> listOfPlannedNotifications;

  // ignore: unused_field
  late Timer _timer;

  Future<void> _startTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      await checkForScheduledNotifications();
    });
  }

  @override
  Future<void> pushNotification(
    NotificationModel notification,
    List<String> recipientIds, [
    Function(NotificationModel model)? onNewNotification,
  ]) async {
    try {
      var userId = FirebaseAuth.instanceFor(app: _firebaseApp).currentUser?.uid;

      if (userId == null) {
        debugPrint("User is not authenticated");
        return;
      }

      for (var recipientId in recipientIds) {
        CollectionReference notifications =
            FirebaseFirestore.instanceFor(app: _firebaseApp)
                .collection(activeNotificationsCollection)
                .doc(recipientId)
                .collection(activeNotificationsCollection);

        var currentDateTime = DateTime.now();
        notification.dateTimePushed = currentDateTime;
        var notificationMap = notification.toMap();
        await notifications.doc(notification.id).set(notificationMap);
      }
      if (recipientIds.contains(userId)) {
        listOfActiveNotifications = [
          ...listOfActiveNotifications,
          notification,
        ];

        //Show popup with notification conte
        if (onNewNotification != null) {
          onNewNotification(notification);
        } else {
          newNotificationCallback(notification);
        }
      }

      notifyListeners();
    } on Exception catch (e) {
      debugPrint("Error creating document: $e");
    }
  }

  @override
  Future<List<NotificationModel>> getActiveNotifications() async {
    try {
      var userId = FirebaseAuth.instanceFor(app: _firebaseApp).currentUser?.uid;

      if (userId == null) {
        debugPrint("User is not authenticated");
        return [];
      }

      CollectionReference activeNotificationsResult =
          FirebaseFirestore.instanceFor(app: _firebaseApp)
              .collection(activeNotificationsCollection)
              .doc(userId)
              .collection(activeNotificationsCollection);

      var querySnapshot = await activeNotificationsResult.get();

      var activeNotifications = querySnapshot.docs.map((doc) {
        var data = doc.data()! as Map<String, dynamic>;
        data["id"] = doc.id;
        return NotificationModel.fromJson(data);
      }).toList();

      listOfActiveNotifications = List.from(activeNotifications);

      listOfActiveNotifications.removeWhere((element) => element.isPinned);
      activeNotifications
          .sort((a, b) => b.dateTimePushed!.compareTo(a.dateTimePushed!));

      listOfActiveNotifications
          .sort((a, b) => b.dateTimePushed!.compareTo(a.dateTimePushed!));

      listOfActiveNotifications.insertAll(
        0,
        activeNotifications.where((element) => element.isPinned),
      );

      notifyListeners();
      return listOfActiveNotifications;
    } on Exception catch (e) {
      debugPrint("Error getting active notifications: $e");
      return [];
    }
  }

  @override
  Future<void> createRecurringNotification(
    NotificationModel notification,
  ) async {
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
      await createScheduledNotification(notification);
    }
  }

  @override
  Future<void> createScheduledNotification(
    NotificationModel notification,
  ) async {
    try {
      var userId = FirebaseAuth.instanceFor(app: _firebaseApp).currentUser?.uid;

      if (userId == null) {
        debugPrint("User is not authenticated");
        return;
      }

      CollectionReference plannedNotifications =
          FirebaseFirestore.instanceFor(app: _firebaseApp)
              .collection(plannedNotificationsCollection)
              .doc(userId)
              .collection(plannedNotificationsCollection);

      var notificationMap = notification.toMap();
      await plannedNotifications.doc(notification.id).set(notificationMap);
    } on Exception catch (e) {
      debugPrint("Error creating document: $e");
    }
  }

  @override
  Future<void> deletePlannedNotification(
    NotificationModel notificationModel,
  ) async {
    try {
      var userId = FirebaseAuth.instanceFor(app: _firebaseApp).currentUser?.uid;

      if (userId == null) {
        debugPrint("User is not authenticated");
        return;
      }

      DocumentReference documentReference =
          FirebaseFirestore.instanceFor(app: _firebaseApp)
              .collection(plannedNotificationsCollection)
              .doc(userId)
              .collection(plannedNotificationsCollection)
              .doc(notificationModel.id);
      await documentReference.delete();

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instanceFor(app: _firebaseApp)
              .collection(plannedNotificationsCollection)
              .doc(userId)
              .collection(plannedNotificationsCollection)
              .get();

      if (querySnapshot.docs.isEmpty) {
        debugPrint("The collection is now empty");
      } else {
        debugPrint(
          "Deleted planned notification with title: ${notificationModel.title}",
        );
      }
    } on Exception catch (e) {
      debugPrint("Error deleting document: $e");
    }
  }

  @override
  Future<void> dismissActiveNotification(
    NotificationModel notificationModel,
  ) async {
    try {
      var userId = FirebaseAuth.instanceFor(app: _firebaseApp).currentUser?.uid;

      if (userId == null) {
        debugPrint("User is not authenticated");
        return;
      }

      DocumentReference documentReference =
          FirebaseFirestore.instanceFor(app: _firebaseApp)
              .collection(activeNotificationsCollection)
              .doc(userId)
              .collection(activeNotificationsCollection)
              .doc(notificationModel.id);
      await documentReference.delete();
      listOfActiveNotifications
          .removeWhere((element) => element.id == notificationModel.id);
      notifyListeners();
    } on Exception catch (e) {
      debugPrint("Error deleting document: $e");
    }
  }

  @override
  Future<void> pinActiveNotification(
    NotificationModel notificationModel,
  ) async {
    try {
      var userId = FirebaseAuth.instanceFor(app: _firebaseApp).currentUser?.uid;

      if (userId == null) {
        debugPrint("User is not authenticated");
        return;
      }

      DocumentReference documentReference =
          FirebaseFirestore.instanceFor(app: _firebaseApp)
              .collection(activeNotificationsCollection)
              .doc(userId)
              .collection(activeNotificationsCollection)
              .doc(notificationModel.id);
      await documentReference.update({"isPinned": true});
      notificationModel.isPinned = true;

      listOfActiveNotifications
          .removeAt(listOfActiveNotifications.indexOf(notificationModel));
      listOfActiveNotifications.insert(0, notificationModel);

      notifyListeners();
    } on Exception catch (e) {
      debugPrint("Error updating document: $e");
    }
  }

  @override
  Future<void> unPinActiveNotification(
    NotificationModel notificationModel,
  ) async {
    try {
      var userId = FirebaseAuth.instanceFor(app: _firebaseApp).currentUser?.uid;

      if (userId == null) {
        debugPrint("User is not authenticated");
        return;
      }

      DocumentReference documentReference =
          FirebaseFirestore.instanceFor(app: _firebaseApp)
              .collection(activeNotificationsCollection)
              .doc(userId)
              .collection(activeNotificationsCollection)
              .doc(notificationModel.id);
      await documentReference.update({"isPinned": false});
      notificationModel.isPinned = false;

      listOfActiveNotifications
          .removeAt(listOfActiveNotifications.indexOf(notificationModel));

      listOfActiveNotifications.add(notificationModel);

      notifyListeners();
    } on Exception catch (e) {
      debugPrint("Error updating document: $e");
    }
  }

  @override
  Future<void> markNotificationAsRead(
    NotificationModel notificationModel,
  ) async {
    try {
      var userId = FirebaseAuth.instanceFor(app: _firebaseApp).currentUser?.uid;

      if (userId == null) {
        debugPrint("User is not authenticated");
        return;
      }

      DocumentReference documentReference =
          FirebaseFirestore.instanceFor(app: _firebaseApp)
              .collection(activeNotificationsCollection)
              .doc(userId)
              .collection(activeNotificationsCollection)
              .doc(notificationModel.id);
      await documentReference.update({"isRead": true});
      notificationModel.isRead = true;
      notifyListeners();
    } on Exception catch (e) {
      debugPrint("Error updating document: $e");
    }
  }

  @override
  Future<void> checkForScheduledNotifications() async {
    var currentTime = DateTime.now();
    try {
      var userId = FirebaseAuth.instanceFor(app: _firebaseApp).currentUser?.uid;

      if (userId == null) {
        debugPrint("User is not authenticated");
        return;
      }

      CollectionReference plannedNotificationsResult =
          FirebaseFirestore.instanceFor(app: _firebaseApp)
              .collection(plannedNotificationsCollection)
              .doc(userId)
              .collection(plannedNotificationsCollection);

      var querySnapshot = await plannedNotificationsResult.get();

      if (querySnapshot.docs.isEmpty) {
        return;
      }

      var plannedNotifications = querySnapshot.docs.map((doc) {
        var data = doc.data()! as Map<String, dynamic>;
        return NotificationModel.fromJson(data);
      }).toList();

      for (var notification in plannedNotifications) {
        if (notification.scheduledFor!.isBefore(currentTime) ||
            notification.scheduledFor!.isAtSameMomentAs(currentTime)) {
          await pushNotification(
            notification,
            [userId],
            newNotificationCallback,
          );

          await deletePlannedNotification(notification);

          //Plan new recurring notification instance
          if (notification.recurring) {
            var newNotification = NotificationModel(
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
    } on Exception catch (e) {
      debugPrint("Error getting planned notifications: $e");
      return;
    }
  }

  @override
  Stream<int> getActiveAmountStream() async* {
    var userId = FirebaseAuth.instanceFor(app: _firebaseApp).currentUser?.uid;

    if (userId == null) {
      debugPrint("User is not authenticated");
      yield 0;
    }

    var amount = FirebaseFirestore.instanceFor(app: _firebaseApp)
        .collection(activeNotificationsCollection)
        .doc(userId)
        .collection(activeNotificationsCollection)
        .where("isRead", isEqualTo: false)
        .snapshots()
        .map((e) => e.docs.length);
    yield* amount;
  }
}
