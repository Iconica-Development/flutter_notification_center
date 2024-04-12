import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const _errorMessage = 'Unable to fetch dotenv, did you make sure to generate '
    'your build environment config?\nUse the command: '
    'dart pub run environment_config:generate\n'
    'For more information, look at the readme\n'
    'Using default now...';

/// This environment config is used for the features inside the package
/// The project that uses this package should have their own environment config
/// the values in the dotenv should atleast include the following:
mixin SharedEnvironmentConfig {}

/// This environment config is used only for the firebase configuration
mixin SharedFirebaseEnvironmentConfig {
  static String get firebaseAppName {
    var firebaseAppName = dotenv.env['FIREBASE_APP_NAME'];
    if (firebaseAppName == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseAppName;
  }
}
