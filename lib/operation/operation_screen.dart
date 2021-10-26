import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OperationScreen extends StatefulWidget {
  const OperationScreen({Key? key}) : super(key: key);

  @override
  _OperationScreenState createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(38.4762271, 27.0778775), zoom: 14);

  late GoogleMapController _googleMapController;
  Set<Marker> _markers = {};

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: _markers,
        onLongPress: _addMarker,
        initialCameraPosition: _initialCameraPosition,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (controller) => _googleMapController = controller,
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        child: Icon(Icons.center_focus_strong),
        onPressed: () {
          _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
      ),
    );
  }

  void _addMarker(LatLng argument) {
    _markers.add(
      Marker(
          markerId: MarkerId(DateTime.now().toIso8601String()),
          infoWindow: InfoWindow(title: 'marker'),
          icon: BitmapDescriptor.defaultMarker,
          position: argument),
    );
    setState(() {});
  }
}
