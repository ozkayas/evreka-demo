import 'package:flutter/material.dart';
import 'package:google_map_i/connectivity/connectivity_service.dart';

class NetworkSensitive extends StatelessWidget {
  final Widget child;
  //final double opacity;
  NetworkSensitive({
    required this.child,
    //this.opacity = 0.5,
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityStatus>(
        stream: ConnectivityService().connectionStatusController.stream,
        builder: (_, asyncSnapshot) {
          switch (asyncSnapshot.data) {
            case ConnectivityStatus.WiFi:
              return child;
            case ConnectivityStatus.Cellular:
              return child;
            case ConnectivityStatus.WifiNoNet:
              return WifiNoNet();
            case ConnectivityStatus.CellularNoNet:
              return CellularNoNet();
            case ConnectivityStatus.Offline:
              return OfflineDevice();

            default:
              return OfflineDevice();
          }
        });
  }
}

class WifiNoNet extends StatelessWidget {
  const WifiNoNet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Your wifi is on but no network detected.\n Please check your network settings and try again later",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CellularNoNet extends StatelessWidget {
  const CellularNoNet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Your cellular data is on but no network detected.\n Please check your network settings and try again later",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class OfflineDevice extends StatelessWidget {
  const OfflineDevice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Please turn on either Wifi or Cellular Network"),
      ),
    );
  }
}
