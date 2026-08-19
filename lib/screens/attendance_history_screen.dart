import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/attendance_model.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  Future<List<AttendanceRecord>> _localRecords() async {
    final box = Hive.box('attendance');
    return box.values.map((e) => AttendanceRecord.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance History')),
      body: FutureBuilder<List<AttendanceRecord>>(
        future: _localRecords(),
        builder: (_, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final items = snap.data!;
          if (items.isEmpty) return const Center(child: Text('No records'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final it = items[i];
              return ListTile(
                title: Text(it.studentName),
                subtitle: Text('${it.classId} • ${it.timestamp} • ${it.method}${it.latitude != null ? ' • ${it.latitude},${it.longitude}' : ''}'),
              );
            },
          );
        },
      ),
    );
  }
}
