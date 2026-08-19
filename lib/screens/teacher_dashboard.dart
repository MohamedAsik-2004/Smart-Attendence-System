import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Dashboard')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Teacher features: generate QR, take attendance, reports'),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.attendance), child: const Text('Take Attendance')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.qrscan), child: const Text('Scan QR')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.teacherQr), child: const Text('Generate QR')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.teacherStudents), child: const Text('Student List')),
        ]),
      ),
    );
  }
}
