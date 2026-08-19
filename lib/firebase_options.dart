// File generated from your Firebase project: smart-attendance-79be5
// https://console.firebase.google.com/project/smart-attendance-79be5

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
    apiKey: 'AIzaSyDD9_lwEoUbsDazOxR-AG3xZHZtBF44Ntw',
    appId: '1:637339576400:web:747b434d62c831b175c955',
    messagingSenderId: '637339576400',
    projectId: 'smart-attendance-79be5',
    authDomain: 'smart-attendance-79be5.firebaseapp.com',
    storageBucket: 'smart-attendance-79be5.firebasestorage.app',
    measurementId: 'G-9E4QZ33J04',
  );

  // ─── ANDROID ────────────────────────────────────────────────────────────────
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDD9_lwEoUbsDazOxR-AG3xZHZtBF44Ntw',
    appId: '1:637339576400:web:747b434d62c831b175c955',
    messagingSenderId: '637339576400',
    projectId: 'smart-attendance-79be5',
    storageBucket: 'smart-attendance-79be5.firebasestorage.app',
  );

  // ─── iOS ────────────────────────────────────────────────────────────────────
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDD9_lwEoUbsDazOxR-AG3xZHZtBF44Ntw',
    appId: '1:637339576400:web:747b434d62c831b175c955',
    messagingSenderId: '637339576400',
    projectId: 'smart-attendance-79be5',
    storageBucket: 'smart-attendance-79be5.firebasestorage.app',
    iosBundleId: 'com.example.smartAttendanceApp',
  );

  // ─── WINDOWS ────────────────────────────────────────────────────────────────
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDD9_lwEoUbsDazOxR-AG3xZHZtBF44Ntw',
    appId: '1:637339576400:web:747b434d62c831b175c955',
    messagingSenderId: '637339576400',
    projectId: 'smart-attendance-79be5',
    storageBucket: 'smart-attendance-79be5.firebasestorage.app',
    measurementId: 'G-9E4QZ33J04',
  );
}
