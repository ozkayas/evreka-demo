import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:google_map_i/models/container.dart';
import 'package:google_map_i/navigation/navigator.dart';
import 'package:google_map_i/operation/database_service.dart';
import 'package:google_map_i/operation/relocation_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OperationScreenViewModel extends GetxController {
  final _db = DatabaseService();
  final markers = <Marker>[].obs;

  /// TODO: assetsler icinden ayirilacak
  BitmapDescriptor? defaultMarkerIcon;
  BitmapDescriptor? selectedMarkerIcon;
  BitmapDescriptor? disabledMarkerIcon;

  void navigateToMarker(ContainerX container) async {
    NavigationService.navigateToMarker(container.lat, container.long);
  }

  void openRelocateScreen(BuildContext context, ContainerX container) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => RelocationScreen(container: container)));
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center();
      },
    );
  }

  initMarketIcons() async {
    var markerIcon = await getBytesFromAsset('assets/household_bin.png', 100);
    defaultMarkerIcon = BitmapDescriptor.fromBytes(markerIcon);
    markerIcon = await getBytesFromAsset('assets/battery_bin.png', 100);
    selectedMarkerIcon = BitmapDescriptor.fromBytes(markerIcon);
    disabledMarkerIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    // await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(size: Size(30, 30)), 'assets/household_bin.png');
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Stream<List<ContainerX>> streamOfContainers() {
    var containers = _db.fetchContainers();

    ///Stream<QuerySnapshot> ==> Stream<List<DocumentSnaphot>>
    Stream<List<DocumentSnapshot>> streamListDocumentSnapshot =
        containers.map((querySnapshot) => querySnapshot.docs);

    // streamListDocumentSnapshot.first
    //     .then((value) => print('value = ${value.first['id']}'));

    ///tream<List<DocumentSnaphot>> ==> Stream<List<ContainerX>>
    var streamListContainer = streamListDocumentSnapshot.map(
        (listDocumentSnapshot) => listDocumentSnapshot
            .map((documentSnapshot) => ContainerX.fromJson(
                documentSnapshot.data() as Map<String, dynamic>))
            .toList());

    // streamListContainer.first
    //     .then((value) => print('first container ${value.first}'));

    return streamListContainer;
  }

/*   Stream<List<Marker>> streamOfMarkers() {
    var containers = _db.fetchContainers();

    ///Stream<QuerySnapshot> ==> Stream<List<DocumentSnaphot>>
    Stream<List<DocumentSnapshot>> streamListDocumentSnapshot =
        containers.map((querySnapshot) => querySnapshot.docs);

    ///tream<List<DocumentSnaphot>> ==> Stream<List<Marker>>
    var streamListMarker = streamListDocumentSnapshot.map(
        (listDocumentSnapshot) => listDocumentSnapshot
            .map((documentSnapshot) => ContainerX.fromJson(
                    documentSnapshot.data() as Map<String, dynamic>)
                .toMarker(() {},defaultMarkerIcon))
            .toList());

    return streamListMarker;
  } */
}
