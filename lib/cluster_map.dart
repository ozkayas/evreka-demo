// Clustering maps

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_map_i/contants.dart';
import 'package:google_map_i/operation/operation_screen_viewmodel.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'models/container.dart';

class MapSample extends StatefulWidget {
  const MapSample({
    Key? key,
    required List<ContainerX> containers,
    required CameraPosition initialCameraPosition,
  })  : _containers = containers,
        _initialCameraPosition = initialCameraPosition,
        super(key: key);
  final List<ContainerX> _containers;
  final CameraPosition _initialCameraPosition;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  OperationScreenViewModel _viewModel = Get.find();
  late ClusterManager _manager;
  late List<ContainerX> _containers;
  bool markerSelectionMode = false;
  bool showRelocateDialog = false;

  Completer<GoogleMapController> _controller = Completer();
  ContainerX? _selectedContainer;

  Set<Marker> markers = Set();
  late final CameraPosition _initialCameraPosition;
  // final CameraPosition _parisCameraPosition =
  //     CameraPosition(target: LatLng(48.856613, 2.352222), zoom: 12.0);

  late List<Place> items;

  void fillItems() {
    items = widget._containers
        .map((container) => Place(
            name: container.id, latLng: LatLng(container.lat, container.long)))
        .toList();
  }

  @override
  void initState() {
    print('initstate build');
    _initialCameraPosition = widget._initialCameraPosition;
    _containers = widget._containers;
    fillItems();
    _manager = _initClusterManager();
    super.initState();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(items, _updateMarkers,
        markerBuilder: _markerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this.markers = markers;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleMarkerClick(String id) {
    markerSelectionMode = true;
    setSelectedContainer(id);
    _manager.updateMap();
    //setState(() {});
  }

  void setSelectedContainer(String id) {
    _selectedContainer =
        _containers.firstWhere((container) => container.id == id);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    _manager.setItems(widget._containers
        .map((container) => Place(
            name: container.id, latLng: LatLng(container.lat, container.long)))
        .toList());

    return Container(
        child: Stack(children: [
      GoogleMap(
          onTap: (_) {
            dismissMarkerSelection();
          },
          mapType: MapType.normal,
          initialCameraPosition: _initialCameraPosition,
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _manager.setMapId(controller.mapId);
          },
          onCameraMove: _manager.onCameraMove,
          onCameraIdle: _manager.updateMap),
      if (markerSelectionMode) buildContainerInfoCard(textTheme),
      if (showRelocateDialog) buildRelocatiInfoCard(textTheme)
    ]));
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: cluster.isMultiple
              //if cluster  method
              ? () {
                  print('---- $cluster');
                  cluster.items.forEach((p) => print(p));
                }
              // if single marker method
              : () {
                  print('single marker clicked ${cluster.items.first.name}');
                  handleMarkerClick(cluster.items.first.name);
                },
          icon: cluster.isMultiple
              ? await _getMarkerBitmap(cluster.isMultiple ? 125 : 100,
                  text: cluster.isMultiple ? cluster.count.toString() : null)
              : (_selectedContainer == null)
                  ? _viewModel.defaultMarkerIcon!
                  : (cluster.items.first.name == _selectedContainer!.id)
                      ? _viewModel.selectedMarkerIcon!
                      : _viewModel.defaultMarkerIcon!,
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    // final Paint paint1 = Paint()..color = Colors.orange;
    // final Paint paint2 = Paint()..color = Colors.white;
    final Paint paint1 = Paint()..color = AppColor.Green.color;
    final Paint paint2 = Paint()..color = AppColor.ShadowColorGreen.color;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  void dismissMarkerSelection() {
    markerSelectionMode = false;
    _selectedContainer = null;
    _manager.updateMap();
  }

  Widget buildContainerInfoCard(TextTheme textTheme) {
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
          padding: EdgeInsets.fromLTRB(16, 25, 16, 19),
          decoration: boxDecoration,
          width: 336,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_selectedContainer!.id, style: textTheme.headline3),
                    SizedBox(height: 5.0),
                    Text('Next Collection', style: textTheme.headline4),
                    Text(
                        '${DateTime.fromMillisecondsSinceEpoch(_selectedContainer!.lastDataDate)}',
                        style: textTheme.bodyText1),
                    SizedBox(height: 5.0),
                    Text(
                      'Fullness Rate',
                      style: textTheme.headline4,
                    ),
                    Text(
                      '%${_selectedContainer!.fullnessRate * 100}',
                      style: textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 13.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cardButton(() {
                    _viewModel.navigateToMarker(_selectedContainer!);
                  }, AppConstant.navigate, textTheme),
                  SizedBox(
                    width: 22,
                  ),
                  _cardButton(() async {
                    final result = await _viewModel.openRelocateScreen(
                        context, _selectedContainer!);
                    markerSelectionMode = false;

                    // If user taps backbutton result returns as null
                    if (result ?? false) {
                      dismissMarkerSelection();
                      showRelocateDialog = true;
                      setState(() {
                        showRelocateDialog = true;
                        //createMarkers();
                      });

                      await Future.delayed(Duration(seconds: 3));

                      setState(() {
                        showRelocateDialog = false;
                      });
                    }
                  }, AppConstant.relocate, textTheme),
                ],
              )
            ],
          ),
        ));
  }

  Widget buildRelocatiInfoCard(TextTheme textTheme) {
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
          padding: EdgeInsets.fromLTRB(15, 35, 15, 35),
          decoration: boxDecoration,
          //width: MediaQuery.of(context).size.width * 0.94,
          width: 336,
          //height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstant.relocateSuccesfullMessage,
                    style: textTheme.bodyText1,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Expanded _cardButton(Function onTap, String title, TextTheme textTheme) {
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
              style: textTheme.button,
            )),
      ),
    );
  }
}

class Place with ClusterItem {
  final String name;
  final LatLng latLng;

  Place({required this.name, required this.latLng});

  @override
  LatLng get location => latLng;
}
