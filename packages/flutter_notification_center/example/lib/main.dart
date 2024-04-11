import 'package:example/customer_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_notification_center_firebase/flutter_notification_center_firebase.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_notification_center/flutter_notification_center.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureApp();
  await initializeDateFormatting();
  await _signInUser();

  runApp(
    ChangeNotifierProvider(
      create: (_) => FirebaseNotificationService(),
      child: const MaterialApp(
        home: NotificationCenterDemo(),
      ),
    ),
  );
}

Future<void> _configureApp() async {
  try {
    await dotenv.load(fileName: 'dotenv');
  } catch (e) {
    debugPrint('Failed to load dotenv file: $e');
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );
}

Future<void> _signInUser() async {
  //TO DO: Implement your own sign in logic
}

class NotificationCenterDemo extends StatefulWidget {
  const NotificationCenterDemo({super.key});

  @override
  State<NotificationCenterDemo> createState() => _NotificationCenterDemoState();
}

class _NotificationCenterDemoState extends State<NotificationCenterDemo> {
  @override
  Widget build(BuildContext context) {
    var config = NotificationConfig(
      service: Provider.of<FirebaseNotificationService>(context),
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
        notificationService: Provider.of<FirebaseNotificationService>(context),
        notificationTranslations: const NotificationTranslations(),
        context: context,
      ),
      seperateNotificationsWithDivider: true,
    );

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