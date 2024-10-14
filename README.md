# flutter_notification_center

`flutter_notification_center` is a comprehensive and flexible notification management package for Flutter applications. It allows developers to integrate real-time notifications, schedule messages, and provide an interactive notification center, with support for Firebase and local data storage. The package is highly customizable, enabling developers to adjust the UI, translate notification messages, and configure notifications to enhance user engagement.

---

## Table of Contents
- [Features](#features)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
  - [Setting Up Firebase](#setting-up-firebase)
  - [Configuring the Notification Center](#configuring-the-notification-center)
  - [Displaying Notifications](#displaying-notifications)
- [Customization](#customization)
  - [UI Customization](#ui-customization)
  - [Translations](#translations)
- [API Reference](#api-reference)
- [Examples](#examples)
- [Issues](#issues)
- [Contributing](#contribute)
- [Author](#author)

---

## Features

- **Real-time Notifications**: Fetch and display active notifications in real-time.
- **Scheduled and Recurring Notifications**: Set notifications for future delivery or create recurring notifications.
- **Interactive Notification Center**: Display notifications with interactive options to dismiss, pin, or mark them as read.
- **Customizable UI**: Adjust UI elements like icons, colors, and layout of the notification center.
- **Localization**: Easily translate notification messages for multiple languages.
- **Modular Architecture**: Compatible with Firebase and local storage solutions, allowing flexibility in backend configuration.

---

## Getting Started

### Core Components
1. **Notification Center**: Provides a UI for displaying notifications.
2. **Notification Bell**: Displays the count of active notifications with animation support.
3. **Notification Service**: Manages notifications, including adding, deleting, and retrieving notifications.

### Requirements
1. **Firebase**: Firebase should be initialized for storing notifications in Firestore. 
2. **User Identification**: Each user requires a unique `userId` for personalized notifications.

---

## Installation

1. **Add Dependencies**: Add required dependencies in `pubspec.yaml`.

    ```yaml
    dependencies:
      firebase_notification_center_repository:
      git:
        url: https://github.com/Iconica-Development/flutter_notification_center.git
        path: packages/firebase_notification_center_repository
        ref: 5.0.0
      notification_center_repository_interface:
        git:
          url: https://github.com/Iconica-Development/flutter_notification_center.git
          path: packages/notification_center_repository_interface
          ref: 5.0.0
      flutter_notification_center:
        git:
          url: https://github.com/Iconica-Development/flutter_notification_center.git
          path: packages/flutter_notification_center
          ref: 5.0.0
      firebase_core: ^latest_version
      cloud_firestore: ^latest_version
      intl: ^latest_version
    ```

2. **Firebase Setup**:
   - Follow [Firebase setup instructions](https://firebase.google.com/docs/flutter/setup) for both Android and iOS.
   - Ensure Firestore is configured with `active_notifications` and `planned_notifications` collections for immediate and scheduled notifications, respectively.

3. **Asset Configuration**:
   - Some icons, like `unpin_icon.svg`, may need to be referenced in `pubspec.yaml`.

    ```yaml
    flutter:
      assets:
        - assets/unpin_icon.svg
    ```

4. **Initialize Firebase**:
   - Initialize Firebase in the `main.dart` file.

    ```dart
    import 'package:firebase_core/firebase_core.dart';
    import 'package:flutter/material.dart';

    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      runApp(MyApp());
    }
    ```

---

## Usage

### Setting Up Firebase

1. **Initialize FirebaseNotificationRepository**:
   - This repository interacts with Firebase Firestore for managing notifications.

    ```dart
    final notificationRepository = FirebaseNotificationRepository(
      activeNotificationsCollection: "active_notifications",
      plannedNotificationsCollection: "planned_notifications",
    );
    ```

2. **Firestore Configuration**:
   - Ensure Firestore is correctly set up with appropriate collections.

### Configuring the Notification Center

1. **NotificationBell Widget**:
   - Displays the count of active notifications.

    ```dart
    final notificationBell = NotificationBell(
      config: NotificationConfig(),
      service: notificationService, // An instance of NotificationService
      onTap: () {
        // Define behavior when tapped, e.g., navigate to NotificationCenter
      },
    );
    ```

2. **NotificationCenter Widget**:
   - Displays a list of notifications, allowing users to interact with each one.

    ```dart
    final notificationCenter = NotificationCenter(
      config: NotificationConfig(
        translations: NotificationTranslations(appBarTitle: "Notifications"),
        showAsSnackBar: true,
        enableNotificationPopups: true,
      ),
      service: notificationService,
    );
    ```

### Displaying Notifications

1. **Adding Notifications**:
   - Use `addNotification` to add new notifications to the repository.

    ```dart
    final newNotification = NotificationModel(
      id: "123",
      title: "New Alert",
      body: "You have a new notification",
      scheduledFor: DateTime.now().add(Duration(days: 1)),
    );

    notificationRepository.addNotification("user_id", newNotification, ["recipient_id"]);
    ```

2. **Streaming Notifications**:
   - Use `getNotifications` to listen to real-time updates of active notifications.

    ```dart
    notificationRepository.getNotifications("user_id").listen((notifications) {
      for (var notification in notifications) {
        print(notification.title);
      }
    });
    ```

3. **Deleting Notifications**:
   - Remove a notification by calling `deleteNotification`.

    ```dart
    notificationRepository.deleteNotification("user_id", "notification_id", false);
    ```

---

## Customization

### UI Customization

1. **Notification Bell Styling**:
   - Customize the `NotificationBell` appearance with `AnimatedNotificationBellStyle`.

    ```dart
    final notificationBell = NotificationBell(
      animatedIconStyle: AnimatedNotificationBellStyle(
        color: Colors.blue,
        size: 24,
      ),
      onTap: () { /* Navigate to NotificationCenter */ },
    );
    ```

2. **Notification Display Layout**:
   - Customize the `NotificationCenter` layout with `NotificationConfig`, adjusting elements like the app bar title, icon color, and UI interactions.

    ```dart
    final notificationConfig = NotificationConfig(
      showAsSnackBar: true,
      enableNotificationPopups: true,
      pinnedIconColor: Colors.green,
    );
    ```

### Translations

1. **Localized Translations**:
   - `NotificationTranslations` provides customizable text for various notification messages.

    ```dart
    final translations = NotificationTranslations(
      appBarTitle: "Mis Notificaciones",
      notificationDismissed: "Notificación descartada",
      notificationPinned: "Notificación fijada",
      notificationUnpinned: "Notificación desmarcada",
    );

    final notificationConfig = NotificationConfig(translations: translations);
    ```

2. **Dialog Customization**:
   - Adjust dialog text within `NotificationDialog` using custom translations, ideal for supporting multiple languages.

---

## API Reference

### Classes

- **NotificationService**: Manages notifications, with methods for adding, updating, deleting, and scheduling.
- **NotificationModel**: Represents a notification structure with fields like `id`, `title`, `body`, and `scheduledFor`.
- **NotificationConfig**: Customization class for notifications, allowing display options like snackbar or dialog.
- **NotificationRepositoryInterface**: Defines the required methods for a notification repository, enabling various backend implementations.
- **LocalNotificationRepository**: In-memory implementation, useful for testing.
  
### Key Methods

- `addNotification(userId, notification, recipientIds)`: Adds a new notification.
- `deleteNotification(userId, id, planned)`: Deletes a notification.
- `getNotifications(userId)`: Streams active notifications.
- `getPlannedNotifications(userId)`: Streams scheduled notifications.
- `updateNotification(userId, notification)`: Updates an existing notification.

---

## Examples

### Basic Usage

```dart
final firebaseRepo = FirebaseNotificationRepository();

final notification = NotificationModel(
  id: "notif_01",
  title: "Welcome!",
  body: "Thank you for signing up.",
  scheduledFor: DateTime.now().add(Duration(hours: 1)),
);

// Adding a notification
await firebaseRepo.addNotification("user_123", notification, ["user_123"]);

// Listening to active notifications
firebaseRepo.getNotifications("user_123").listen((notifications) {
  notifications.forEach((notif) => print(notif.title));
});
```

---
### Advaned Usage With Custom Translations
```dart
final translations = NotificationTranslations(
  appBarTitle: "My Custom Notifications",
  noNotifications: "No notifications at this time.",
);

final notificationConfig = NotificationConfig(
  translations: translations,
  showAsSnackBar: true,
);

// Using the config in a custom notification center setup
final notificationCenter = NotificationCenter(
  config: notificationConfig,
  service: firebaseRepo,
);
```

See [Example Code](example/lib/main.dart) for more info.

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/Iconica-Development/flutter_notification_center/pulls) page. Commercial support is available if you need help with integration with your app or services. You can contact us at [support@iconica.nl](mailto:support@iconica.nl).

## Contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](./CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_notification_center/pulls).

## Author

This `flutter_notification_center` for Flutter is developed by [Iconica](https://iconica.nl). You can contact us at <support@iconica.nl>
