import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/auth_provider.dart';
import '../repositories/attendance_repository.dart';
import 'attendance_history_screen.dart';
import '../routes/app_routes.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceRepository _repo = AttendanceRepository();
  bool _loading = false;

  Future<void> _markManual(String uid, String name) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _loading = true);
    try {
      final r = _repo.createRecord(studentId: uid, studentName: name, classId: 'default-class', method: 'manual');
      await _repo.addLocal(r);
      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('Attendance saved locally')));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _markLocation(String uid, String name) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _loading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        if (!mounted) return;
        messenger.showSnackBar(const SnackBar(content: Text('Location permission denied')));
        return;
      }
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final r = _repo.createRecord(
        studentId: uid,
        studentName: name,
        classId: 'default-class',
        method: 'location',
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
      await _repo.addLocal(r);
      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('Location attendance saved locally')));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final canSubmit = !_loading && user != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Logged in as: ${user?.name ?? user?.email ?? ''}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: canSubmit ? () => _markManual(user.uid, user.name) : null,
              child: _loading ? const CircularProgressIndicator() : const Text('Mark Attendance (Manual)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: canSubmit ? () => Navigator.pushNamed(context, AppRoutes.qrscan) : null,
              child: const Text('Open QR Scanner'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: canSubmit ? () => _markLocation(user.uid, user.name) : null,
              child: _loading ? const CircularProgressIndicator() : const Text('Mark Attendance (Location)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceHistoryScreen())),
              child: const Text('View Local History'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                await _repo.syncAll();
                if (!mounted) return;
                messenger.showSnackBar(const SnackBar(content: Text('Sync attempted')));
              },
              child: const Text('Force Sync'),
            ),
          ],
        ),
      ),
    );
  }
}
