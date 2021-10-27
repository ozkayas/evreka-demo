import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_i/models/container.dart';
import 'package:google_map_i/operation/operation_screen_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OperationScreen extends StatefulWidget {
  const OperationScreen({Key? key}) : super(key: key);

  @override
  _OperationScreenState createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  OperationScreenViewModel _viewModel = Get.put(OperationScreenViewModel());
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Marker>>(
                stream: _viewModel.streamOfMarkers(),
                builder: (context, asyncSnapshot) {
                  var data = asyncSnapshot.data;
                  _markers = data!.toSet();
                  return GoogleMap(
                    markers: _markers,
                    //onLongPress: _addMarker,
                    initialCameraPosition: _initialCameraPosition,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (controller) =>
                        _googleMapController = controller,
                  );
                }),
          ),
          // Expanded(
          //   child: GoogleMap(
          //     markers: _markers,
          //     onLongPress: _addMarker,
          //     initialCameraPosition: _initialCameraPosition,
          //     myLocationButtonEnabled: false,
          //     zoomControlsEnabled: false,
          //     onMapCreated: (controller) => _googleMapController = controller,
          //   ),
          // ),
        ],
      ),
      //floatingActionButton: getContainerData(),
    );
  }

/*   FloatingActionButton getContainerData() {
    return FloatingActionButton(
        foregroundColor: Colors.green,
        child: Icon(Icons.center_focus_strong),
        onPressed: () async {
          var containerDocRef = FirebaseFirestore.instance
              .collection('containers')
              .doc('container001');
          var response = await containerDocRef.get();
          Map<String, dynamic> data = response.data() as Map<String, dynamic>;
          GeoPoint position = data['position'];
          Timestamp timeStamp = data['lastDataDate']
        });
  } */

/*   FloatingActionButton animateCamera() {
    return FloatingActionButton(
      foregroundColor: Colors.black,
      child: Icon(Icons.center_focus_strong),
      onPressed: () {
        _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(_initialCameraPosition));
      },
    );
  } */

/*   void _addMarker(LatLng argument) {
    _markers.add(
      Marker(
          markerId: MarkerId(DateTime.now().toIso8601String()),
          infoWindow: InfoWindow(title: 'marker'),
          icon: BitmapDescriptor.defaultMarker,
          position: argument),
    );
    setState(() {});
  } */
}
