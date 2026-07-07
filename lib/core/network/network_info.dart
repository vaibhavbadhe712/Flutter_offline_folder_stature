import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Contract for checking and observing network connectivity.
abstract class NetworkInfo {
  /// Returns true if the device is currently connected to a network.
  Future<bool> get isConnected;

  /// Stream of network status updates.
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl() : _connectivity = Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
