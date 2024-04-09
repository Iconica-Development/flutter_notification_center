import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'environment.dart';

mixin FirebaseInstance {
  static FirebaseApp instance() =>
      SharedFirebaseEnvironmentConfig.firebaseAppName.isEmpty
          ? Firebase.app()
          : Firebase.app(SharedFirebaseEnvironmentConfig.firebaseAppName);
}

mixin Database {
  static FirebaseFirestore ref() => FirebaseFirestore.instanceFor(
        app: FirebaseInstance.instance(),
      );
}

mixin Storage {
  static Reference ref({bool prefixed = true}) =>
      FirebaseStorage.instanceFor(app: FirebaseInstance.instance()).ref();
}
