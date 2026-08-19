import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassManagementScreen extends StatefulWidget {
  const ClassManagementScreen({super.key});

  @override
  State<ClassManagementScreen> createState() => _ClassManagementScreenState();
}

class _ClassManagementScreenState extends State<ClassManagementScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _className = TextEditingController();
  final _classId = TextEditingController();
  bool _saving = false;

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final doc = _firestore.collection('classes').doc();
    await doc.set({'classId': doc.id, 'className': _className.text.trim(), 'classCode': _classId.text.trim()});
    _className.clear();
    _classId.clear();
    setState(() => _saving = false);
  }

  Future<void> _delete(String id) async {
    await _firestore.collection('classes').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Classes')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(controller: _className, decoration: const InputDecoration(labelText: 'Class Name'), validator: (v) => v == null || v.isEmpty ? 'Enter class name' : null),
              TextFormField(controller: _classId, decoration: const InputDecoration(labelText: 'Class Code'), validator: (v) => v == null || v.isEmpty ? 'Enter class code' : null),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _saving ? null : _create, child: _saving ? const CircularProgressIndicator() : const Text('Create')),
            ]),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('classes').snapshots(),
              builder: (_, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final d = docs[i];
                    return ListTile(
                      title: Text(d['className'] ?? d['classCode'] ?? 'Class'),
                      subtitle: Text('Code: ${d['classCode'] ?? ''}'),
                      trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => _delete(d['classId'] ?? d.id)),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}