import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const _errorMessage = 'Unable to fetch dotenv, did you make sure to generate '
    'your build environment config?\nUse the command: '
    'flutter pub run environment_config:generate\n'
    'For more information, look at the readme\n'
    'Using default now...';

class EnvironmentConfig {
  String get firebaseProjectId {
    var firebaseProjectId = dotenv.env['FIREBASE_PROJECT_ID'];
    if (firebaseProjectId == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseProjectId;
  }

  String get firebaseMessageId {
    var firebaseMessageId = dotenv.env['FIREBASE_MESSAGE_ID'];
    if (firebaseMessageId == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseMessageId;
  }

  String get firebaseAuthDomain {
    var firebaseAuthDomain = dotenv.env['FIREBASE_AUTH_DOMAIN'];
    if (firebaseAuthDomain == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseAuthDomain;
  }

  String get firebaseStorageUrl {
    var firebaseStorageUrl = dotenv.env['FIREBASE_STORAGE_URL'];
    if (firebaseStorageUrl == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseStorageUrl;
  }

  String get firebaseDatabaseUrl {
    var firebaseDatabaseUrl = dotenv.env['FIREBASE_DATABASE_URL'];
    if (firebaseDatabaseUrl == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseDatabaseUrl;
  }

  String get firebaseWebApiKey {
    var firebaseKey = dotenv.env['FIREBASE_WEB_API_KEY'];
    if (firebaseKey == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseKey;
  }

  String get firebaseIosApiKey {
    var firebaseKey = dotenv.env['FIREBASE_IOS_API_KEY'];
    if (firebaseKey == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseKey;
  }

  String get firebaseAndroidApiKey {
    var firebaseKey = dotenv.env['FIREBASE_ANDROID_API_KEY'];
    if (firebaseKey == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseKey;
  }

  String get firebaseAppIdAndroid {
    var firebaseAppIdAndroid = dotenv.env['FIREBASE_APP_ID_ANDROID'];
    if (firebaseAppIdAndroid == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseAppIdAndroid;
  }

  String get firebaseAppIdIos {
    var firebaseAppIdIos = dotenv.env['FIREBASE_APP_ID_IOS'];
    if (firebaseAppIdIos == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseAppIdIos;
  }

  String get firebaseAppIdMacos {
    var firebaseAppIdMacos = dotenv.env['FIREBASE_APP_ID_MACOS'];
    if (firebaseAppIdMacos == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseAppIdMacos;
  }

  String get firebaseAppIdWeb {
    var firebaseAppIdWeb = dotenv.env['FIREBASE_APP_ID_WEB'];
    if (firebaseAppIdWeb == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseAppIdWeb;
  }

  String get firebaseClientIdIos {
    var firebaseClientIdIos = dotenv.env['FIREBASE_CLIENT_ID_IOS'];
    if (firebaseClientIdIos == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseClientIdIos;
  }

  String get firebaseClientIdMacos {
    var firebaseClientIdMacos = dotenv.env['FIREBASE_CLIENT_ID_MACOS'];
    if (firebaseClientIdMacos == null) {
      debugPrint(_errorMessage);
      throw Exception(_errorMessage);
    }
    return firebaseClientIdMacos;
  }
}
