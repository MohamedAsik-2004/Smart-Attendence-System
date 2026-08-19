import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FaceRecognitionScreen extends StatefulWidget {
  const FaceRecognitionScreen({super.key});

  @override
  State<FaceRecognitionScreen> createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  File? _image;
  final bool _processing = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.camera, maxWidth: 800);
    if (x == null) return;
    setState(() => _image = File(x.path));
    // stub: run ML face detection later
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Recognition (stub)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          if (_image != null) Image.file(_image!, height: 300),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _processing ? null : _pickImage, child: const Text('Capture Face')),
          const SizedBox(height: 8),
          const Text('This screen is a stub. Integrate google_ml_kit face detector for production.')
        ]),
      ),
    );
  }
}
