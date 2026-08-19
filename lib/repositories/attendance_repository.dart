import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/attendance_model.dart';

class AttendanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  Future<void> addLocal(AttendanceRecord r) async {
    final box = Hive.box('attendance');
    await box.put(r.id, r.toMap());
  }

  Future<List<AttendanceRecord>> getLocal() async {
    final box = Hive.box('attendance');
    return box.values.map((e) => AttendanceRecord.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> syncAll() async {
    final box = Hive.box('attendance');
    final keys = box.keys.toList();
    for (final k in keys) {
      final data = Map<String, dynamic>.from(box.get(k));
      // push to firestore
      await _firestore.collection('attendance').add(data);
      await box.delete(k);
    }
  }

  AttendanceRecord createRecord({required String studentId, required String studentName, required String classId, required String method, double? latitude, double? longitude}) {
    final id = _uuid.v4();
    return AttendanceRecord(
      id: id,
      studentId: studentId,
      studentName: studentName,
      classId: classId,
      method: method,
      timestamp: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
    );
  }
}
