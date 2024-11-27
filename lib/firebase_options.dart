// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyCH2Wu3gwxr4yEAnEq010XDnwsU_4WD4BE',
    appId: '1:263365595629:web:7b94634ef5a2cb77f2d7e4',
    messagingSenderId: '263365595629',
    projectId: 'mobile-app-7dabb',
    authDomain: 'mobile-app-7dabb.firebaseapp.com',
    storageBucket: 'mobile-app-7dabb.firebasestorage.app',
    measurementId: 'G-962TQWV82T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSOkbt-g6INW7cb_6TbafWYVsOiVBzIhY',
    appId: '1:263365595629:android:d54e320efdabcd81f2d7e4',
    messagingSenderId: '263365595629',
    projectId: 'mobile-app-7dabb',
    storageBucket: 'mobile-app-7dabb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCsCCxm-Jq2qqOuEqcERanr-_zWzFT5-Us',
    appId: '1:263365595629:ios:26e1b2f52bc6d6cbf2d7e4',
    messagingSenderId: '263365595629',
    projectId: 'mobile-app-7dabb',
    storageBucket: 'mobile-app-7dabb.firebasestorage.app',
    iosBundleId: 'com.example.mobileApp',
  );

}