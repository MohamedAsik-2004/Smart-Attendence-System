import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Student features: mark attendance, view history, timetable'),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.attendance), child: const Text('Mark Attendance')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.qrscan), child: const Text('Open QR Scanner')),
        ]),
      ),
    );
  }
}
