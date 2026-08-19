import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (FirebaseService.initialized) {
    await Firebase.initializeApp();
  }
}

class PushService {
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Local notifications — not supported on web, skip silently
    if (!kIsWeb) {
      try {
        await _local.initialize(
          const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          ),
        );
      } catch (e) {
        debugPrint('[PushService] local notifications init failed: $e');
      }
    }

    // Firebase Messaging — only if Firebase initialised successfully
    if (!FirebaseService.initialized) return;

    try {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      final fm = FirebaseMessaging.instance;
      await fm.requestPermission();
      FirebaseMessaging.onMessage.listen((message) {
        if (kIsWeb) return; // local notifications not available on web
        final notif = message.notification;
        if (notif != null) {
          _local.show(
            notif.hashCode,
            notif.title,
            notif.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'sa_channel',
                'Smart Attendance',
                importance: Importance.max,
              ),
            ),
          );
        }
      });
    } catch (e) {
      debugPrint('[PushService] Firebase Messaging setup failed: $e');
    }
  }
}

