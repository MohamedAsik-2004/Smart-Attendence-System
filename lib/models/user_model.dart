class AppUser {
  final String uid;
  final String email;
  final String role; // 'student' | 'teacher' | 'admin'
  final String name;

  AppUser({required this.uid, required this.email, required this.role, required this.name});

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'role': role,
        'name': name,
      };

  factory AppUser.fromMap(Map<String, dynamic> m) => AppUser(
        uid: m['uid'] ?? '',
        email: m['email'] ?? '',
        role: m['role'] ?? 'student',
        name: m['name'] ?? '',
      );
}
