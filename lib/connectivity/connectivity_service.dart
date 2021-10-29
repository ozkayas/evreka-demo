import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  var isDeviceConnected = false;

  ConnectivityService() {
    // Subscribe to the connectivity Chanaged Steam
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      // Use Connectivity() here to gather more info if you need t

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
