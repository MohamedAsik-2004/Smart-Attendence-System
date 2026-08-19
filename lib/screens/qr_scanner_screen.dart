import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/auth_provider.dart';
import '../repositories/attendance_repository.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  final AttendanceRepository _repo = AttendanceRepository();
  bool _scanned = false;
  final String _statusMessage = 'Point camera at class QR code';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture, AuthProvider auth) async {
    if (_scanned) return;
    final barcode = capture.barcodes.firstOrNull;
    final payload = barcode?.rawValue ?? '';
    if (payload.isEmpty) return;

    _scanned = true;
    final user = auth.user;
    if (user == null) return;

    String classId = payload;
    int? timestamp;

    // Parse dynamic payload: CLASS:<classId>|TS:<timestamp>
    if (payload.contains('CLASS:') && payload.contains('|TS:')) {
      final parts = payload.split('|TS:');
      classId = parts[0].replaceFirst('CLASS:', '');
      timestamp = int.tryParse(parts[1]);
    }

    // Anti-spoofing check: Expiration check (45 seconds validity window)
    if (timestamp != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final ageSeconds = (now - timestamp) / 1000;
      if (ageSeconds > 45) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ QR code expired (${ageSeconds.toInt()}s old). Please scan the live QR code.'),
            backgroundColor: Colors.red.shade700,
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          _scanned = false;
        });
        return;
      }
    }

    // Optional GPS location capture
    double? lat;
    double? lng;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
        lat = pos.latitude;
        lng = pos.longitude;
      }
    } catch (_) {}

    final r = _repo.createRecord(
      studentId: user.uid,
      studentName: user.name,
      classId: classId,
      method: 'qr',
      latitude: lat,
      longitude: lng,
    );
    await _repo.addLocal(r);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Attendance marked for $classId!'),
        backgroundColor: Colors.green.shade700,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Class QR')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: (capture) => _onDetect(capture, auth),
                ),
                // Overlay frame
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: primary, width: 3),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.2),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

