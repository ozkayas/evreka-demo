import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  Future<void> initLocationService() async {
    final location = new Location();
    PermissionStatus _permissionGranted;

    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<LatLng> getLocation() async {
    final location = new Location();
    var locationData = await location.getLocation();
    return LatLng(locationData.latitude!, locationData.longitude!);
  }
}
