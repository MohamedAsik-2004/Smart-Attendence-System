import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TeacherQRGenerator extends StatefulWidget {
  const TeacherQRGenerator({super.key});

  @override
  State<TeacherQRGenerator> createState() => _TeacherQRGeneratorState();
}

class _TeacherQRGeneratorState extends State<TeacherQRGenerator> {
  final _controller = TextEditingController();
  String _classId = '';
  String _currentPayload = '';
  Timer? _timer;
  int _secondsLeft = 15;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startQrRefresh() {
    _timer?.cancel();
    _updatePayload();
    _secondsLeft = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 1) {
          _secondsLeft--;
        } else {
          _secondsLeft = 15;
          _updatePayload();
        }
      });
    });
  }

  void _updatePayload() {
    if (_classId.isEmpty) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    _currentPayload = 'CLASS:$_classId|TS:$now';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Class QR Generator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Class Code',
                        hintText: 'e.g. CS101-SEC-A',
                        prefixIcon: Icon(Icons.class_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _classId = _controller.text.trim();
                        });
                        if (_classId.isNotEmpty) {
                          _startQrRefresh();
                        }
                      },
                      icon: const Icon(Icons.qr_code_2),
                      label: const Text('Generate Live Anti-Spoof QR'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_classId.isNotEmpty) ...[
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.circle, color: Colors.green, size: 10),
                                SizedBox(width: 6),
                                Text(
                                  'LIVE ROTATING QR',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: QrImageView(
                          data: _currentPayload,
                          size: 240.0,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Class: $_classId',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: _secondsLeft / 15,
                        color: primary,
                        backgroundColor: primary.withValues(alpha: 0.2),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Refreshes in $_secondsLeft seconds (Anti-Screenshot Protection)',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

