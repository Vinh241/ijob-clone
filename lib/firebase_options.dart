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
    apiKey: 'AIzaSyDBe9U6LbvzRJbRWDelLZWBHYjz4zsNybY',
    appId: '1:469296308974:web:6423e6373d5377b42e09ff',
    messagingSenderId: '469296308974',
    projectId: 'ijob-clone-app-662f9',
    authDomain: 'ijob-clone-app-662f9.firebaseapp.com',
    storageBucket: 'ijob-clone-app-662f9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZ-RitU5vTZYZU9UV-vyu4u9HhccJH_Gc',
    appId: '1:469296308974:android:0c837f000d1a7ca42e09ff',
    messagingSenderId: '469296308974',
    projectId: 'ijob-clone-app-662f9',
    storageBucket: 'ijob-clone-app-662f9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBv2Pxmyh6U-ZdwzY5lrsiCJU0v4z3zUzc',
    appId: '1:469296308974:ios:d786b10ca24868fb2e09ff',
    messagingSenderId: '469296308974',
    projectId: 'ijob-clone-app-662f9',
    storageBucket: 'ijob-clone-app-662f9.appspot.com',
    iosClientId: '469296308974-2tc87g89kfp6dg5a54i4s3qh2l1h2ubg.apps.googleusercontent.com',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBv2Pxmyh6U-ZdwzY5lrsiCJU0v4z3zUzc',
    appId: '1:469296308974:ios:d786b10ca24868fb2e09ff',
    messagingSenderId: '469296308974',
    projectId: 'ijob-clone-app-662f9',
    storageBucket: 'ijob-clone-app-662f9.appspot.com',
    iosClientId: '469296308974-2tc87g89kfp6dg5a54i4s3qh2l1h2ubg.apps.googleusercontent.com',
    iosBundleId: 'com.example.project',
  );
}