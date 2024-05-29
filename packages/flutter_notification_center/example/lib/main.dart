import 'package:example/custom_notification.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:example/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_notification_center_firebase/flutter_notification_center_firebase.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_notification_center/flutter_notification_center.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureApp();
  await initializeDateFormatting();
  await _signInUser();

  runApp(
    const MaterialApp(
      home: NotificationCenterDemo(),
    ),
  );
}

Future<void> _configureApp() async {
  // await Firebase.initializeApp(
  // options: DefaultFirebaseOptions.currentPlatform,
  // );
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );
}

Future<void> _signInUser() async {
  /// Implement your own sign in logic here
}

class NotificationCenterDemo extends StatefulWidget {
  const NotificationCenterDemo({super.key});

  @override
  State<NotificationCenterDemo> createState() => _NotificationCenterDemoState();
}

class _NotificationCenterDemoState extends State<NotificationCenterDemo> {
  late NotificationConfig config;
  late PopupHandler popupHandler;

  @override
  void initState() {
    super.initState();
    var service = FirebaseNotificationService(
      newNotificationCallback: (notification) {
        popupHandler.handleNotificationPopup(notification);
      },
    );
    config = NotificationConfig(
      service: service,
      enableNotificationPopups: true,
      showAsSnackBar: true,
      notificationWidgetBuilder: (notification, context) =>
          CustomNotificationWidget(
        notification: notification,
        style: const NotificationStyle(
          appTitleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          leadingIconColor: Colors.grey,
          pinnedIconColor: Colors.grey,
          isReadDotColor: Colors.red,
          showNotificationIcon: true,
        ),
        notificationService: service,
        notificationTranslations: const NotificationTranslations.empty(),
        context: context,
      ),
      seperateNotificationsWithDivider: true,
    );
    popupHandler = PopupHandler(context: context, config: config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Center Demo'),
        centerTitle: true,
        actions: [
          NotificationBellWidgetStory(
            config: config,
          ),
        ],
      ),
      body: const SizedBox.shrink(),
    );
  }
}
