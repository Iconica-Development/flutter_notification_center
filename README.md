# flutter_notification_center
A Flutter package for creating notification center displaying a list of notifications.

## Features

- Notification center: A page containing a list of notifications.
- Notification bell: A clickable bell icon that can be placed anywere showing the amound of unread notifications. Clicking the bell takes the user to the notification center.
- Pinned notifications: A pinned notification can't be dismissed by the user from the notification center.
- Dismissable notifications: A dismissable notification can be dismissed by the user from the notification center.
- Notification detail page: Clicking on a notification takes the user to a notification detail page.
- Notification types: Notification types that can be created are: instant, scheduled, recurring.
- Notification popups: If a notification is pushed a popup can appear in form of a dialog or snackbar.

## Setup

To use this package, add `flutter_notification_center` as a dependency in your pubspec.yaml file.

- For custom notification styling provide the optional notificationWidgetBuilder with your own implementation.

The `NotificationConfig` has its own parameters, as specified below:
| Parameter | Explanation |
|-----------|-------------|
| service | The notification service that will be used |
| seperateNotificationsWithDivider | If true notifications will be seperated with dividers within the notification center |
| translations | The translations that will be used |
| notificationWidgetBuilder | The widget that defines the styles and logic for every notification |
| enableNotificationPopups | If set to false no popups will be shown if a new notification is pushed |
| showAsSnackBar | If true notifications popups will show as snackbar. If false shown as dialog|

If you set `enableNotificationPopups` to true, you can use `PopupHandler` in the `newNotificationCallback` to display popups in case a new notification is pushed.

The `notificationWidgetBuilder` expects the following parameters, as specified below:
| Parameter | Explanation |
|-----------|-------------|
| notification | The notification that is being defined |
| style | The styling that will be used for the notification |
| notificationService | The notification service that will be used |
| notificationTranslations | The translations that will be used for the notification|
| context | The provided context |

## Usage
Create instant notification: 
- Make a call to pushNotification() and provide a NotificationModel with the required attributes.

Create scheduled notification: 
- Make a call to createScheduledNotification() and provide a NotificationModel with the required attributes + scheduledFor.

Create recurring notification: 
- Make a call to createRecurringNotification() and provide a NotificationModel with the required attributes and the following additional attributes:
    - scheduledFor
    - recurring = true
    - occuringInterval with the pre defined interval (daily, weekly, monthly)

To create a pinned notification, set isPinned = true when creating the notification.

### Example

See [Example Code](example/lib/main.dart) for more info.

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/Iconica-Development/flutter_notification_center/pulls) page. Commercial support is available if you need help with integration with your app or services. You can contact us at [support@iconica.nl](mailto:support@iconica.nl).

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](./CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_notification_center/pulls).

## Author

This `flutter_notification_center` for Flutter is developed by [Iconica](https://iconica.nl). You can contact us at <support@iconica.nl>
