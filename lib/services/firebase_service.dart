import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import '../firebase_options.dart';

class FirebaseService {
  static bool initialized = false;

  static Future<void> initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      initialized = true;
    } catch (e) {
      // Firebase init failed (e.g. placeholder API keys or network issue).
      // The app will run in offline/demo mode — auth and Firestore will not work.
      debugPrint('[FirebaseService] Firebase init failed: $e');
      initialized = false;
    }
  }
}
