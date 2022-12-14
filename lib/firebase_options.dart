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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC2wj4BQ2AVYPZiMIttmV4VafmlIl0rjs4',
    appId: '1:1055744031287:web:21418916c76db419d31db2',
    messagingSenderId: '1055744031287',
    projectId: 'crud-flutter-c2bc0',
    authDomain: 'crud-flutter-c2bc0.firebaseapp.com',
    storageBucket: 'crud-flutter-c2bc0.appspot.com',
    measurementId: 'G-QGZH70C6SD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCqXXIqs3NdnS6NjfD7uWGWmjtE2wG1mUo',
    appId: '1:1055744031287:android:077063c46561bcf6d31db2',
    messagingSenderId: '1055744031287',
    projectId: 'crud-flutter-c2bc0',
    storageBucket: 'crud-flutter-c2bc0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDhlNLDFMUl1uZQStEKWE9miJ4DnUY2E48',
    appId: '1:1055744031287:ios:1315a4c0f31a1018d31db2',
    messagingSenderId: '1055744031287',
    projectId: 'crud-flutter-c2bc0',
    storageBucket: 'crud-flutter-c2bc0.appspot.com',
    iosClientId: '1055744031287-dckv5thhjogq7dbasusqjgs75m957jae.apps.googleusercontent.com',
    iosBundleId: 'com.example.crudFlutter',
  );
}
