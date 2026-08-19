// File generated from your Firebase project: smart-attendence-2abfc
// https://console.firebase.google.com/project/smart-attendence-2abfc

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ─── WEB ────────────────────────────────────────────────────────────────────
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCU7GIjpHc91bPjtSokUcGF6EhVdKOQT-A',
    appId: '1:1094532655728:web:8f5bff4e3e5c7e470922b5',
    messagingSenderId: '1094532655728',
    projectId: 'smart-attendence-2abfc',
    authDomain: 'smart-attendence-2abfc.firebaseapp.com',
    storageBucket: 'smart-attendence-2abfc.firebasestorage.app',
    measurementId: 'G-ZCDN1QJW85',
  );

  // ─── ANDROID ────────────────────────────────────────────────────────────────
  // Values from android/app/google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBK2Wh5VxAfy-8AtshC_wzT0XdXjSkryqg',
    appId: '1:1094532655728:android:6570386832fec7980922b5',
    messagingSenderId: '1094532655728',
    projectId: 'smart-attendence-2abfc',
    storageBucket: 'smart-attendence-2abfc.firebasestorage.app',
  );

  // ─── iOS ────────────────────────────────────────────────────────────────────
  // TODO: Download GoogleService-Info.plist from Firebase Console → Project settings
  //       → iOS app and place it in ios/Runner/
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCU7GIjpHc91bPjtSokUcGF6EhVdKOQT-A',
    appId: '1:1094532655728:ios:REPLACE_WITH_IOS_APP_ID',
    messagingSenderId: '1094532655728',
    projectId: 'smart-attendence-2abfc',
    storageBucket: 'smart-attendence-2abfc.firebasestorage.app',
    iosBundleId: 'com.example.smartAttendanceApp',
  );

  // ─── WINDOWS ────────────────────────────────────────────────────────────────
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCU7GIjpHc91bPjtSokUcGF6EhVdKOQT-A',
    appId: '1:1094532655728:web:8f5bff4e3e5c7e470922b5',
    messagingSenderId: '1094532655728',
    projectId: 'smart-attendence-2abfc',
    storageBucket: 'smart-attendence-2abfc.firebasestorage.app',
    measurementId: 'G-ZCDN1QJW85',
  );
}
