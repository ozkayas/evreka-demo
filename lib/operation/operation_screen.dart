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
  Map<String, Marker> markers = <String, Marker>{};
  bool markedSelectionMode = false;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Marker yellowMarker = Marker(
    markerId: MarkerId('yellow Marker'),
    position: LatLng(38.480, 27.08),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    infoWindow: InfoWindow(title: 'selected'),
  );

  void fillMarkers(List<ContainerX> list) {
    _markers =
        list.map((container) => container.toMarker(handleMarkerClick)).toSet();
  }

  void handleMarkerClick(String id) {
    markedSelectionMode = true;

    var updatedMarkers = _markers
        .map((marker) => marker.mapsId.value == id ? yellowMarker : marker)
        .toSet();
    setState(() {
      _markers = updatedMarkers;
    });

    //markedSelectionMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ContainerX>>(
                stream: _viewModel.streamOfContainers(),
                builder: (context, asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List<ContainerX> data = asyncSnapshot.data!;
                    if (!markedSelectionMode) {
                      fillMarkers(data);
                    }
                    return GoogleMap(
                      markers: _markers,
                      initialCameraPosition: _initialCameraPosition,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (controller) =>
                          _googleMapController = controller,
                    );
                  }
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
