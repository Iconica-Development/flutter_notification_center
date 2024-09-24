// import 'package:example/firebase_options.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notification_center_repository/firebase_notification_center_repository.dart';
// import 'package:example/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_core/firebase_core.dart';
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
  // Generate a FirebaseOptions and uncomment the following lines to initialize Firebase.
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
  // Sign in, you could use the line below or implement your own sign in method.
  // await FirebaseAuth.instance.signInAnonymously();
}

class NotificationCenterDemo extends StatefulWidget {
  const NotificationCenterDemo({super.key});

  @override
  State<NotificationCenterDemo> createState() => _NotificationCenterDemoState();
}

class _NotificationCenterDemoState extends State<NotificationCenterDemo> {
  late NotificationService service;
  // Provide a user ID here. For Firebase you can use the commented line below.
  String userId = ""; //FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    service = NotificationService(
      userId: userId,
      repository: FirebaseNotificationRepository(),
    );

    // Uncomment the line below to send a test notification.
    // Provide a user ID in the list to send the notification to.
    _sendTestNotification([userId]);
  }

  _sendTestNotification(List<String> recipientIds) async {
    await service.pushNotification(
      NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Test Notification',
        body: 'This is a test notification.',
        // For a scheduled message provide a scheduledFor date.
        // For a recurring message provide a scheduledFor date, set recurring to true and provide an occuringInterval.
        //
        // scheduledFor: DateTime.now().add(const Duration(seconds: 5)),
        // recurring: true,
        // occuringInterval: OcurringInterval.debug,
      ),
      recipientIds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Center Demo'),
        centerTitle: true,
        actions: [
          NotificationBellWidgetStory(
            userId: userId,
            service: service,
          ),
        ],
      ),
      body: const SizedBox.shrink(),
    );
  }
}
