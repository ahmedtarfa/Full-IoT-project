// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBRaAW_JZDkD2SwhXvnHKNNNx8TJdaEOZI',
    appId: '1:201871774286:web:a2f19e8f8645db653c691f',
    messagingSenderId: '201871774286',
    projectId: 'iot3-flutter',
    authDomain: 'iot3-flutter.firebaseapp.com',
    databaseURL: 'https://iot3-flutter-default-rtdb.firebaseio.com',
    storageBucket: 'iot3-flutter.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCNvfd9olzwfTceLlBHNtqSk9kt_dL9yo',
    appId: '1:201871774286:android:7ea18fda8da594593c691f',
    messagingSenderId: '201871774286',
    projectId: 'iot3-flutter',
    databaseURL: 'https://iot3-flutter-default-rtdb.firebaseio.com',
    storageBucket: 'iot3-flutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAg7sOB3OqeYDlKTvs9lvAEcgX8oUCUIiw',
    appId: '1:201871774286:ios:833e4c451c3c6b063c691f',
    messagingSenderId: '201871774286',
    projectId: 'iot3-flutter',
    databaseURL: 'https://iot3-flutter-default-rtdb.firebaseio.com',
    storageBucket: 'iot3-flutter.appspot.com',
    iosClientId: '201871774286-s50ddpvub1saqq28p1bttu1ed5kteacf.apps.googleusercontent.com',
    iosBundleId: 'com.example.iot66',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAg7sOB3OqeYDlKTvs9lvAEcgX8oUCUIiw',
    appId: '1:201871774286:ios:2c5f514b11c344663c691f',
    messagingSenderId: '201871774286',
    projectId: 'iot3-flutter',
    databaseURL: 'https://iot3-flutter-default-rtdb.firebaseio.com',
    storageBucket: 'iot3-flutter.appspot.com',
    iosClientId: '201871774286-fg45vsil7c17ktk8kcic9325fg8d1e9i.apps.googleusercontent.com',
    iosBundleId: 'com.example.iot66.RunnerTests',
  );
}
