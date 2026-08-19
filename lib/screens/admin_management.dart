import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class AdminManagementScreen extends StatelessWidget {
  const AdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.adminCrud), child: const Text('Manage Students')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.adminCrud), child: const Text('Manage Teachers')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.classMgmt), child: const Text('Manage Classes')),
        ]),
      ),
    );
  }
}
