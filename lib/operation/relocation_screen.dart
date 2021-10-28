import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_i/models/container.dart';
import 'package:google_map_i/operation/operation_screen_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RelocationScreen extends StatefulWidget {
  const RelocationScreen({Key? key, required this.container}) : super(key: key);
  final ContainerX container;

  @override
  _RelocationScreenState createState() => _RelocationScreenState();
}

class _RelocationScreenState extends State<RelocationScreen> {
  OperationScreenViewModel _viewModel = Get.find();
  late final ContainerX container;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    container = widget.container;
    _markers.add(container.toMarker(() {}, _viewModel.selectedMarkerIcon));
  }

  @override
  Widget build(BuildContext context) {
    var _initialCameraPosition =
        CameraPosition(target: LatLng(container.lat, container.long), zoom: 14);
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          markers: _markers,
        ),
        RelocationInfoCard(container: container, viewModel: _viewModel)
      ]),
    );
  }
}

class RelocationInfoCard extends StatelessWidget {
  final OperationScreenViewModel viewModel;
  final ContainerX container;
  const RelocationInfoCard(
      {Key? key, required this.container, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoxDecoration boxDecoration = BoxDecoration(boxShadow: [
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
    ], color: Color(0xFFFBFCFF), borderRadius: BorderRadius.circular(8.0));

    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 30),
          padding: EdgeInsets.fromLTRB(15, 16, 16, 15),
          decoration: boxDecoration,
          //width: MediaQuery.of(context).size.width * 0.94,
          width: 336,
          //height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please select a location from the map for your bin to be relocated. You can select a location by tapping on the map.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.openSans(
                    fontSize: 16, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cardButton(() {}, 'SAVE'),
                ],
              )
            ],
          ),
        ));
  }

  Expanded _cardButton(Function onTap, String title) {
    return Expanded(
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
    );
  }
}
