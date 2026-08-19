import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _conn = Connectivity();

  Stream<ConnectivityResult> get onConnectivityChanged => _conn.onConnectivityChanged;

  Future<bool> get isOnline async {
    final res = await _conn.checkConnectivity();
    return res != ConnectivityResult.none;
  }
}
