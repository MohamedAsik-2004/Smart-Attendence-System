import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/admin_dashboard.dart';
import '../screens/teacher_dashboard.dart';
import '../screens/student_dashboard.dart';
import '../screens/qr_scanner_screen.dart';
import '../screens/attendance_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/admin_management.dart';
import '../screens/teacher_qr_generator.dart';
import '../screens/teacher_student_list.dart';
import '../screens/admin_crud_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/class_management_screen.dart';
import '../screens/face_recognition_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const admin = '/admin';
  static const teacher = '/teacher';
  static const student = '/student';
  static const qrscan = '/qrscan';
  static const attendance = '/attendance';
  static const reports = '/reports';
  static const adminMgmt = '/admin-mgmt';
  static const teacherQr = '/teacher-qr';
  static const teacherStudents = '/teacher-students';
  static const adminCrud = '/admin-crud';
  static const analytics = '/analytics';
  static const classMgmt = '/class-mgmt';
  static const faceRec = '/face-rec';

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case admin:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      case teacher:
        return MaterialPageRoute(builder: (_) => const TeacherDashboard());
      case student:
        return MaterialPageRoute(builder: (_) => const StudentDashboard());
      case attendance:
        return MaterialPageRoute(builder: (_) => const AttendanceScreen());
      case reports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      case adminMgmt:
        return MaterialPageRoute(builder: (_) => const AdminManagementScreen());
      case teacherQr:
        return MaterialPageRoute(builder: (_) => const TeacherQRGenerator());
      case teacherStudents:
        return MaterialPageRoute(builder: (_) => const TeacherStudentList());
      case adminCrud:
        return MaterialPageRoute(builder: (_) => const AdminCrudScreen());
      case analytics:
        return MaterialPageRoute(builder: (_) => const AnalyticsScreen());
      case classMgmt:
        return MaterialPageRoute(builder: (_) => const ClassManagementScreen());
      case faceRec:
        return MaterialPageRoute(builder: (_) => const FaceRecognitionScreen());
      case qrscan:
        return MaterialPageRoute(builder: (_) => const QRScannerScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
