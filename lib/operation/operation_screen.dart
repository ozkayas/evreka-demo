import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool markerSelectionMode = false;
  Marker? _selectedMarker;

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

  ///Fills markers at first build & when no marker is selected build
  void fillMarkers(List<ContainerX> list) {
    _markers = list
        .map((container) =>
            container.toMarker(handleMarkerClick, _viewModel.defaultMarkerIcon))
        .toSet();
  }

  void setSelectedMarker(String id) {
    _selectedMarker =
        _markers.firstWhere((marker) => marker.mapsId.value == id);
  }

  void changeColorOfSelectedMarker(String id) {
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
  }

  void handleMarkerClick(String id) {
    markerSelectionMode = true;

    changeColorOfSelectedMarker(id);
    setSelectedMarker(id);
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
                    if (!markerSelectionMode) {
                      fillMarkers(data);
                    }
                    return Stack(children: [
                      GoogleMap(
                        onTap: (_) {
                          setState(() {
                            markerSelectionMode = false;
                          });
                        },
                        markers: _markers,
                        initialCameraPosition: _initialCameraPosition,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        onMapCreated: (controller) =>
                            _googleMapController = controller,
                      ),
                      if (markerSelectionMode)
                        ContainerInfoCard(
                          marker: _selectedMarker,
                          viewModel: _viewModel,
                        )
                    ]);
                  }
                }),
          ),
        ],
      ),
      //floatingActionButton: openMap(),
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

class ContainerInfoCard extends StatelessWidget {
  final OperationScreenViewModel viewModel;
  final Marker? marker;
  const ContainerInfoCard(
      {Key? key, required this.marker, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 30),
          padding: EdgeInsets.fromLTRB(16, 25, 24, 25),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFBBBBBB),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: Offset(2, 2), // changes position of shadow
                ),
                BoxShadow(
                  color: Color(0xFFBBBBBB),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: Offset(-2, -2), // changes position of shadow
                )
              ],
              color: Color(0xFFFBFCFF),
              borderRadius: BorderRadius.circular(8.0)),
          width: MediaQuery.of(context).size.width * 0.94,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(marker!.mapsId.value),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cardButton(() {
                    viewModel.navigateTo(marker!);
                  }, 'NAVIGATE'),
                  _cardButton(() {}, 'RELOCATE'),
                ],
              )
            ],
          ),
        ));
  }

  Expanded _cardButton(Function onTap, String title) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0xFF72C875),
              spreadRadius: 0,
              blurRadius: 15,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ]),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.0),
                primary: Color(0xFF3BA935),
              ),
              onPressed: () {
                onTap();
              },
              child: Text(
                title,
                style: GoogleFonts.openSans(
                    color: Color(0xFFFBFCFF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }
}
