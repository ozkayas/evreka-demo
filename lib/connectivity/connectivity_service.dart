import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  var isDeviceConnected = false;

  Future<ConnectivityStatus> hasConnection() async {
    await Future.delayed(Duration(seconds: 3));
    ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      isDeviceConnected = await DataConnectionChecker().hasConnection;
    }
    return _getStatusFromResult(result);
  }

  ConnectivityService() {
    // Subscribe to the connectivity Chanaged Steam
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        isDeviceConnected = await DataConnectionChecker().hasConnection;
      }
      connectionStatusController.add(_getStatusFromResult(result));
    });
  }

  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return isDeviceConnected
            ? ConnectivityStatus.Cellular
            : ConnectivityStatus.CellularNoNet;
      case ConnectivityResult.wifi:
        return isDeviceConnected
            ? ConnectivityStatus.WiFi
            : ConnectivityStatus.WifiNoNet;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}

enum ConnectivityStatus { WiFi, Cellular, Offline, WifiNoNet, CellularNoNet }
