import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../repositories/attendance_repository.dart';

class TeacherStudentList extends StatefulWidget {
  const TeacherStudentList({super.key});

  @override
  State<TeacherStudentList> createState() => _TeacherStudentListState();
}

class _TeacherStudentListState extends State<TeacherStudentList> {
  final _firestore = FirebaseFirestore.instance;
  final AttendanceRepository _repo = AttendanceRepository();
  bool _loading = false;

  Future<void> _mark(String id, String name) async {
    setState(() => _loading = true);
    final r = _repo.createRecord(studentId: id, studentName: name, classId: 'manual-class', method: 'manual');
    await _repo.addLocal(r);
    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marked locally')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').where('role', isEqualTo: 'student').snapshots(),
        builder: (_, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];
              return ListTile(
                title: Text(d['name'] ?? d['email'] ?? 'Student'),
                subtitle: Text(d['email'] ?? ''),
                trailing: ElevatedButton(
                  onPressed: _loading ? null : () => _mark(d['uid'], d['name'] ?? d['email'] ?? ''),
                  child: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Mark'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
