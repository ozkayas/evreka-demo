import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_i/connectivity/network_checker.dart';
import 'package:google_map_i/contants.dart';
import 'package:google_map_i/models/container.dart';
import 'package:google_map_i/operation/operation_screen_viewmodel.dart';
import 'package:google_map_i/operation/relocation_screen_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RelocationScreen extends StatefulWidget {
  const RelocationScreen({Key? key, required this.container}) : super(key: key);
  final ContainerX container;

  @override
  _RelocationScreenState createState() => _RelocationScreenState();
}

class _RelocationScreenState extends State<RelocationScreen> {
  OperationScreenViewModel _viewModel = Get.find();
  RelocationViewModel _relocationViewModel = Get.put(RelocationViewModel());
  late final ContainerX container;
  List<Marker> _markers =
      List.filled(2, Marker(markerId: MarkerId('dummyMarker')));
  //Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    container = widget.container;
    //Set marker lists first element

    _markers[0] = (container.toMarker(() {}, _viewModel.selectedMarkerIcon));
  }

  @override
  Widget build(BuildContext context) {
    var _initialCameraPosition =
        CameraPosition(target: LatLng(container.lat, container.long), zoom: 19);
    return NetworkSensitive(
      child: Scaffold(
        body: Stack(children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: Set.from(_markers),
            onTap: _handleOnTap,
          ),
          RelocationInfoCard(
            handleSave: _handleSave,
          )
        ]),
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   final CollectionReference containersReference =
        //       FirebaseFirestore.instance.collection('containers');

        //   containersReference
        //       .doc('container001')
        //       .update({"position": GeoPoint(38.8, 27.01)});
        // }),
      ),
    );
  }

  void _handleOnTap(LatLng position) {
    // tiklanan yerde sari renkli marker olustur.
    var newMarker = Marker(
        markerId: MarkerId('newMarker'),
        position: position,
        icon: _viewModel.selectedMarkerIcon!);

    // 0.indeksteki markerin rengini degistir
    _markers[0] = _markers.first.copyWith(alphaParam: 0.4);

    // Yeni marker listesi ile sayfayi yenile
    setState(() {
      _markers[1] = (newMarker);
    });
  }

  void _handleSave() {
    container.lat = _markers[1].position.latitude;
    container.long = _markers[1].position.longitude;
    _relocationViewModel.relocateContainer(container);
    Navigator.pop(context, true);
  }
}

class RelocationInfoCard extends StatelessWidget {
  final Function handleSave;
  const RelocationInfoCard({Key? key, required this.handleSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoxDecoration boxDecoration = BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.ShadowColor.color,
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(2, 2), // changes position of shadow
          ),
          BoxShadow(
            color: AppColor.ShadowColor.color,
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(-2, -2), // changes position of shadow
          )
        ],
        color: AppColor.LightColor.color,
        borderRadius: BorderRadius.circular(8.0));

    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 30),
          padding: EdgeInsets.fromLTRB(15, 16, 16, 15),
          decoration: boxDecoration,
          //width: MediaQuery.of(context).size.width * 0.94,
          width: 336,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstant.relocationInforCardText,
                textAlign: TextAlign.justify,
                style: GoogleFonts.openSans(
                    fontSize: 16, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cardButton(() {
                    handleSave();
                  }, AppConstant.save),
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
            color: AppColor.ShadowColorGreen.color,
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
              primary: AppColor.Green.color,
            ),
            onPressed: () {
              onTap();
            },
            child: Text(
              title,
              style: GoogleFonts.openSans(
                  color: AppColor.LightColor.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
