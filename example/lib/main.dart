import 'package:example/config/firebase_options.dart';
import 'package:example/services/firebase_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
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
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  if (user == null) {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: 'freek@iconica.nl',
        password: 'wachtwoord',
      );
    } catch (e) {
      debugPrint('Failed to sign in: $e');
    }
  }
}

class NotificationCenterDemo extends StatefulWidget {
  const NotificationCenterDemo({Key? key}) : super(key: key);

  @override
  State<NotificationCenterDemo> createState() => _NotificationCenterDemoState();
}

class _NotificationCenterDemoState extends State<NotificationCenterDemo> {
  @override
  Widget build(BuildContext context) {
    var config = NotificationConfig(
      service: Provider.of<FirebaseNotificationService>(context),
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
      ),
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
