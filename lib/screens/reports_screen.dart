import 'package:flutter/material.dart';
import '../repositories/attendance_repository.dart';
import '../services/export_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final AttendanceRepository _repo = AttendanceRepository();
  final ExportService _export = ExportService();
  bool _loading = false;
  List rows = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final r = await _repo.getLocal();
    setState(() => rows = r);
  }

  Future<void> _doExportCsv() async {
    setState(() => _loading = true);
    final path = await _export.exportCsv(List.from(rows.cast()), 'attendance_export');
    if (!mounted) return;
    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV saved at: $path')));
  }

  Future<void> _doExportPdf() async {
    setState(() => _loading = true);
    final path = await _export.exportPdf(List.from(rows.cast()), 'attendance_export');
    if (!mounted) return;
    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF saved at: $path')));
  }

  Future<void> _doExportExcel() async {
    setState(() => _loading = true);
    final path = await _export.exportExcel(List.from(rows.cast()), 'attendance_export');
    if (!mounted) return;
    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Excel saved at: $path')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Expanded(
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (_, i) {
                final item = rows[i];
                return ListTile(
                  title: Text(item.studentName),
                  subtitle: Text('${item.classId} • ${item.timestamp} • ${item.method}'),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(onPressed: _loading ? null : _doExportCsv, child: const Text('Export CSV')),
            ElevatedButton(onPressed: _loading ? null : _doExportPdf, child: const Text('Export PDF')),
            ElevatedButton(onPressed: _loading ? null : _doExportExcel, child: const Text('Export Excel')),
          ]),
          if (_loading) const Padding(padding: EdgeInsets.only(top: 12), child: CircularProgressIndicator())
        ]),
      ),
    );
  }
}