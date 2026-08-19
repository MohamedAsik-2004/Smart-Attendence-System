import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import '../models/attendance_model.dart';

class ExportService {
  Future<String> exportCsv(List<AttendanceRecord> rows, String filename) async {
    final List<List<String>> data = [
      ['id', 'studentId', 'studentName', 'classId', 'timestamp', 'method']
    ];
    for (final r in rows) {
      data.add([r.id, r.studentId, r.studentName, r.classId, r.timestamp.toIso8601String(), r.method]);
    }
    final csv = const ListToCsvConverter().convert(data);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename.csv');
    await file.writeAsString(csv);
    return file.path;
  }

  Future<String> exportPdf(List<AttendanceRecord> rows, String filename) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context ctx) {
      return pw.Column(children: [
        pw.Text('Attendance Report', style: pw.TextStyle(fontSize: 20)),
        pw.SizedBox(height: 12),
        pw.TableHelper.fromTextArray(
            headers: ['ID', 'Student', 'Class', 'Timestamp', 'Method'],
            data: rows.map((r) => [r.id, r.studentName, r.classId, r.timestamp.toIso8601String(), r.method]).toList())
      ]);
    }));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  Future<String> exportExcel(List<AttendanceRecord> rows, String filename) async {
    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];
    sheet.appendRow(['ID','Student','Class','Timestamp','Method']);
    for (final r in rows) {
      sheet.appendRow([r.id, r.studentName, r.classId, r.timestamp.toIso8601String(), r.method]);
    }
    final dir = await getApplicationDocumentsDirectory();
    final fileBytes = excel.encode();
    final file = File('${dir.path}/$filename.xlsx');
    await file.writeAsBytes(fileBytes!);
    return file.path;
  }
}
