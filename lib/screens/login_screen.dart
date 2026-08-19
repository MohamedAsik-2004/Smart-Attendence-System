import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  String _role = 'student';
  bool _isRegister = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_isRegister)
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
              ),
              TextFormField(
                controller: _password,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => v == null || v.length < 6 ? 'Password min 6 chars' : null,
              ),
              if (_isRegister)
                DropdownButtonFormField<String>(
                  initialValue: _role,
                  items: const [
                    DropdownMenuItem(value: 'student', child: Text('Student')),
                    DropdownMenuItem(value: 'teacher', child: Text('Teacher')),
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  ],
                  onChanged: (v) => setState(() => _role = v!),
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() => _loading = true);
                        String? err;
                        if (_isRegister) {
                          err = await auth.register(_name.text.trim(), _email.text.trim(), _password.text.trim(), _role);
                        } else {
                          err = await auth.signIn(_email.text.trim(), _password.text.trim());
                        }
                        if (!mounted) return;
                        setState(() => _loading = false);
                        if (err != null) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                        } else {
                          // navigate
                          if (auth.user != null) {
                            if (!context.mounted) return;
                            if (auth.user!.role == 'admin') {
                              Navigator.pushReplacementNamed(context, AppRoutes.admin);
                            } else if (auth.user!.role == 'teacher') {
                              Navigator.pushReplacementNamed(context, AppRoutes.teacher);
                            } else {
                              Navigator.pushReplacementNamed(context, AppRoutes.student);
                            }
                          }
                        }
                      },
                child: _loading ? const CircularProgressIndicator() : Text(_isRegister ? 'Register' : 'Login'),
              ),
              TextButton(
                onPressed: () => setState(() => _isRegister = !_isRegister),
                child: Text(_isRegister ? 'Have an account? Login' : 'Create account'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
