import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = Provider.of<AuthProvider>(context);
    // wait for auth init
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      while (auth.loading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (!mounted) return;
      if (auth.user != null) {
        // route according to role
        if (auth.user!.role == 'admin') {
          Navigator.pushReplacementNamed(context, AppRoutes.admin);
        } else if (auth.user!.role == 'teacher') {
          Navigator.pushReplacementNamed(context, AppRoutes.teacher);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.student);
        }
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
