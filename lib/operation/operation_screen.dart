import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:get/get.dart';
import 'package:google_map_i/models/container.dart';
import 'package:google_map_i/operation/operation_screen_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  void initState() {
    super.initState();
    _viewModel.initMarketIcons();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  void openDialog() {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: Colors.transparent,
            ),
          ),
          insetPadding: EdgeInsets.only(top: 350),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          children: [
            Container(
              width: 336,
              height: 300,
            ),
          ],
        );
      },
    );
  }

  void fillMarkers(List<ContainerX> list) {
    _markers = list
        .map((container) =>
            container.toMarker(handleMarkerClick, _viewModel.defaultMarkerIcon))
        .toSet();
  }

  void handleMarkerClick(String id) {
    markedSelectionMode = true;

    var updatedMarkers = _markers
        .map(
          (marker) => marker.mapsId.value == id
              ? marker.copyWith(iconParam: _viewModel.selectedMarkerIcon)
              : marker.copyWith(iconParam: _viewModel.defaultMarkerIcon),
        )
        .toSet();
    setState(() {
      _markers = updatedMarkers;
    });
    openDialog();
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
                      onTap: (_) {
                        setState(() {
                          markedSelectionMode = false;
                        });
                      },
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
        ],
      ),
      floatingActionButton: openMap(),
    );
  }

  FloatingActionButton openMap() {
    return FloatingActionButton(onPressed: () async {
      var lat = 38.5;
      var lng = 27.09;
      var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");

      await launch(uri.toString());
    });
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
