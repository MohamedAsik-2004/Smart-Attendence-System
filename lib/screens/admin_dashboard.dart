import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Admin features: manage students, teachers, classes, analytics'),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.adminMgmt), child: const Text('Manage Entities')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.reports), child: const Text('View Reports')),
        ]),
      ),
    );
  }
}
