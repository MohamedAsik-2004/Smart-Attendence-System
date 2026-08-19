import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? user;
  bool loading = true;
  bool get firebaseReady => FirebaseService.initialized;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    try {
      await Hive.initFlutter();
      await Hive.openBox('local_cache');
      await Hive.openBox('attendance');
    } catch (_) {}

    if (!firebaseReady) {
      // Firebase not configured — go straight to login in demo mode
      loading = false;
      notifyListeners();
      return;
    }

    FirebaseAuth.instance.authStateChanges().listen((u) async {
      if (u != null) {
        await _loadUser(u.uid);
      } else {
        user = null;
      }
      loading = false;
      notifyListeners();
    });
  }

  Future<void> _loadUser(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        user = AppUser.fromMap(doc.data()!);
        final box = Hive.box('local_cache');
        box.put('user', user!.toMap());
      }
    } catch (e) {
      debugPrint('[AuthProvider] _loadUser failed: $e');
    }
  }

  Future<String?> signIn(String email, String password) async {
    if (!firebaseReady) return 'Firebase is not configured yet.';
    try {
      final cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await _loadUser(cred.user!.uid);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('[AuthProvider] signIn error code: ${e.code}, message: ${e.message}');
      if (e.code == 'user-not-found' || e.code == 'invalid-credential' || e.code == 'INVALID_LOGIN_CREDENTIALS') {
        return 'Account not found or incorrect password. If you do not have an account, please click "Create account" to register first.';
      }
      if (e.code == 'wrong-password') {
        return 'Incorrect password. Please try again.';
      }
      return e.message ?? 'Login failed (${e.code}).';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> register(
      String name, String email, String password, String role) async {
    if (!firebaseReady) return 'Firebase is not configured yet.';
    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final u = AppUser(
          uid: cred.user!.uid, email: email, role: role, name: name);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(u.uid)
          .set(u.toMap());
      user = u;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('[AuthProvider] register error code: ${e.code}, message: ${e.message}');
      if (e.code == 'email-already-in-use') {
        return 'An account already exists with this email. Please login instead.';
      }
      if (e.code == 'weak-password') {
        return 'Password should be at least 6 characters long.';
      }
      return e.message ?? 'Registration failed (${e.code}).';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    if (firebaseReady) {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
    }
    try {
      final box = Hive.box('local_cache');
      await box.delete('user');
    } catch (_) {}
    user = null;
    notifyListeners();
  }
}
