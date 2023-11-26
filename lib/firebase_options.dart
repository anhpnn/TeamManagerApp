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
    apiKey: 'AIzaSyC8CzHCFQ1dzV0Z0hDiWPmKfyF6WhhAHeo',
    appId: '1:674739114302:web:0cd802d9640244aab7dc6f',
    messagingSenderId: '674739114302',
    projectId: 'teammanager-app-d5b63',
    authDomain: 'teammanager-app-d5b63.firebaseapp.com',
    storageBucket: 'teammanager-app-d5b63.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_jtnZnfNy5SIgIELHOyFEwvOkDvXK17Q',
    appId: '1:674739114302:android:23c776d68065ad3ab7dc6f',
    messagingSenderId: '674739114302',
    projectId: 'teammanager-app-d5b63',
    storageBucket: 'teammanager-app-d5b63.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB96zEb5inc9ySaCsU9mtsrQOWr05XDdEA',
    appId: '1:674739114302:ios:c452c8919e84632fb7dc6f',
    messagingSenderId: '674739114302',
    projectId: 'teammanager-app-d5b63',
    storageBucket: 'teammanager-app-d5b63.appspot.com',
    iosBundleId: 'com.example.teamManagerApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB96zEb5inc9ySaCsU9mtsrQOWr05XDdEA',
    appId: '1:674739114302:ios:a426a6b5bd09ccccb7dc6f',
    messagingSenderId: '674739114302',
    projectId: 'teammanager-app-d5b63',
    storageBucket: 'teammanager-app-d5b63.appspot.com',
    iosBundleId: 'com.example.teamManagerApp.RunnerTests',
  );
}
