import 'dart:async';
import '../repositories/attendance_repository.dart';
import 'connectivity_service.dart';

class SyncService {
  final AttendanceRepository _repo;
  final ConnectivityService _conn;
  StreamSubscription? _sub;
  Timer? _timer;

  SyncService(this._repo, this._conn){
    _sub = _conn.onConnectivityChanged.listen((_) async {
      if (await _conn.isOnline) {
        await _repo.syncAll();
      }
    });
  }

  void startPeriodicSync({Duration interval = const Duration(minutes: 5)}){
    _timer?.cancel();
    _timer = Timer.periodic(interval, (t) async {
      if (await _conn.isOnline) await _repo.syncAll();
    });
  }

  void stopPeriodicSync(){
    _timer?.cancel();
    _timer = null;
  }

  void dispose(){
    _sub?.cancel();
    _timer?.cancel();
  }
}
