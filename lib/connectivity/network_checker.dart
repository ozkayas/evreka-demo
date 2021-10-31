/* import 'package:flutter/material.dart';
import 'package:google_map_i/connectivity/connectivity_service.dart';
import 'package:google_map_i/contants.dart';

class NetworkSensitive extends StatelessWidget {
  final Widget child;
  NetworkSensitive({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConnectivityStatus>(
        future: ConnectivityService().hasConnection(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                body: Center(
                    child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearProgressIndicator(
                    color: AppColor.ShadowColorGreen.color,
                    backgroundColor:
                        AppColor.ShadowColorGreen.color.withAlpha(120),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Connecting...'),
                ],
              ),
            )));
          } else if (snapshot.data == ConnectivityStatus.Cellular ||
              snapshot.data == ConnectivityStatus.WiFi) {
            return StreamBuilder<ConnectivityStatus>(
                stream: ConnectivityService().connectionStatusController.stream,
                builder: (_, asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return Scaffold(
                        body: Center(
                            child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LinearProgressIndicator(
                            color: AppColor.ShadowColorGreen.color,
                            backgroundColor:
                                AppColor.ShadowColorGreen.color.withAlpha(120),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Connecting...'),
                        ],
                      ),
                    )));
                  } else {
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
                  }
                });
          } else {
            return Center();
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
          style: TextStyle(fontSize: 16.0),
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
          style: TextStyle(fontSize: 16.0),
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
        child: Text(
          "Please turn on either Wifi or Cellular Network",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
 */