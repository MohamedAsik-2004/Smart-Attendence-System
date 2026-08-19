class AttendanceRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String classId;
  final DateTime timestamp;
  final String method; // qr/manual/location
  final double? latitude;
  final double? longitude;
  final bool synced;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.timestamp,
    required this.method,
    this.latitude,
    this.longitude,
    this.synced = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentId': studentId,
        'studentName': studentName,
        'classId': classId,
        'timestamp': timestamp.toIso8601String(),
        'method': method,
        'latitude': latitude,
        'longitude': longitude,
        'synced': synced,
      };

  factory AttendanceRecord.fromMap(Map<String, dynamic> m) => AttendanceRecord(
        id: m['id'] ?? '',
        studentId: m['studentId'] ?? '',
        studentName: m['studentName'] ?? '',
        classId: m['classId'] ?? '',
        timestamp: DateTime.parse(m['timestamp']),
        method: m['method'] ?? 'manual',
        latitude: m['latitude'] != null ? (m['latitude'] as num).toDouble() : null,
        longitude: m['longitude'] != null ? (m['longitude'] as num).toDouble() : null,
        synced: m['synced'] ?? false,
      );
}
