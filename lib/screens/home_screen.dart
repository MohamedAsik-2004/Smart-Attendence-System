import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final role = auth.user?.role ?? 'guest';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
              onPressed: () async {
                await auth.signOut();
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Welcome, ${auth.user?.name ?? auth.user?.email ?? 'User'}'),
          const SizedBox(height: 12),
          Text('Role: $role'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (role == 'admin') {
                Navigator.pushNamed(context, AppRoutes.admin);
              } else if (role == 'teacher') {
                Navigator.pushNamed(context, AppRoutes.teacher);
              } else {
                Navigator.pushNamed(context, AppRoutes.student);
              }
            },
            child: const Text('Open Role Dashboard'),
          )
        ]),
      ),
    );
  }
}
