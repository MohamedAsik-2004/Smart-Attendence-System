import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminCrudScreen extends StatefulWidget {
  const AdminCrudScreen({super.key});

  @override
  State<AdminCrudScreen> createState() => _AdminCrudScreenState();
}

class _AdminCrudScreenState extends State<AdminCrudScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  String _role = 'student';
  bool _saving = false;

  final _editName = TextEditingController();
  final _editEmail = TextEditingController();
  String _editRole = 'student';
  String _editingId = '';

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final doc = _firestore.collection('users').doc();
    await doc.set({'uid': doc.id, 'name': _name.text.trim(), 'email': _email.text.trim(), 'role': _role});
    _name.clear();
    _email.clear();
    setState(() => _saving = false);
  }

  void _showEditDialog(String id, String name, String email, String role) {
    _editName.text = name;
    _editEmail.text = email;
    _editRole = role;
    _editingId = id;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit User'),
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: _editName, decoration: const InputDecoration(labelText: 'Full name'), validator: (v) => v == null || v.isEmpty ? 'Enter name' : null),
              TextFormField(controller: _editEmail, decoration: const InputDecoration(labelText: 'Email'), validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null),
              DropdownButtonFormField<String>(initialValue: _editRole, items: const [DropdownMenuItem(value: 'student', child: Text('Student')), DropdownMenuItem(value: 'teacher', child: Text('Teacher')), DropdownMenuItem(value: 'admin', child: Text('Admin'))], onChanged: (v) => setState(() => _editRole = v!), decoration: const InputDecoration(labelText: 'Role')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => _update(), child: const Text('Save')),
        ],
      ),
    );
  }

  Future<void> _update() async {
    if (_editName.text.trim().isEmpty || _editEmail.text.trim().isEmpty || !_editEmail.text.trim().contains('@')) return;
    setState(() => _saving = true);
    await _firestore.collection('users').doc(_editingId).update({'name': _editName.text.trim(), 'email': _editEmail.text.trim(), 'role': _editRole});
    setState(() => _saving = false);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete(String id) async {
    await _firestore.collection('users').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin: Manage Users')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Full name'), validator: (v) => v==null||v.isEmpty? 'Enter name': null),
              TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), validator: (v) => v==null||!v.contains('@')? 'Enter valid email': null),
              DropdownButtonFormField<String>(initialValue: _role, items: const [DropdownMenuItem(value: 'student', child: Text('Student')), DropdownMenuItem(value: 'teacher', child: Text('Teacher')), DropdownMenuItem(value: 'admin', child: Text('Admin'))], onChanged: (v)=>setState(()=>_role=v!), decoration: const InputDecoration(labelText: 'Role')),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _saving?null:_create, child: _saving?const CircularProgressIndicator():const Text('Create'))
            ]),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').snapshots(),
              builder: (_, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final d = docs[i];
                    return ListTile(
                      title: Text(d['name'] ?? d['email'] ?? 'User'),
                      subtitle: Text('${d['email'] ?? ''} • ${d['role'] ?? ''}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEditDialog(d['uid'] ?? d.id, d['name'] ?? '', d['email'] ?? '', d['role'] ?? 'student')),
                          IconButton(icon: const Icon(Icons.delete), onPressed: () => _delete(d['uid'] ?? d.id)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}