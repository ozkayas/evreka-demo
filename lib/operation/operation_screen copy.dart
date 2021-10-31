import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_i/connectivity/connectivity_service.dart';
import 'package:google_map_i/connectivity/network_checker.dart';
import 'package:google_map_i/contants.dart';
import 'package:google_map_i/models/container.dart';
import 'package:google_map_i/operation/database_service.dart';
import 'package:google_map_i/operation/operation_screen_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OperationScreenCopy extends StatefulWidget {
  const OperationScreenCopy({Key? key}) : super(key: key);

  @override
  _OperationScreenCopyState createState() => _OperationScreenCopyState();
}

class _OperationScreenCopyState extends State<OperationScreenCopy> {
  OperationScreenViewModel _viewModel = Get.put(OperationScreenViewModel());
  var _initialCameraPosition =
      CameraPosition(target: LatLng(38.4762271, 27.0778775), zoom: 19);

  //Set<Marker> _markers = {};
  late List<ContainerX> _containers;
  bool markerSelectionMode = false;
  bool showRelocateDialog = false;
  //ContainerX? _selectedContainer;

  @override
  void initState() {
    super.initState();
    _viewModel.initMarkerIcons();
    _viewModel.setUserPosition();
    // _initialCameraPosition =
    //     CameraPosition(target: _viewModel.userPosition, zoom: 19);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DatabaseService().addContainer();
        },
      ),
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
                    _containers = asyncSnapshot.data!;
                    //if (!markerSelectionMode) {
                    //createMarkers();
                    //}
                    return MapWidget(
                        containers: _containers,
                        initialCameraPosition: _initialCameraPosition);
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class MapWidget extends StatefulWidget {
  const MapWidget({
    Key? key,
    required List<ContainerX> containers,
    required CameraPosition initialCameraPosition,
  })  : _initialCameraPosition = initialCameraPosition,
        _containers = containers,
        super(key: key);

  final CameraPosition _initialCameraPosition;
  final List<ContainerX> _containers;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  OperationScreenViewModel _viewModel = Get.find();
  var markerSelectionMode = false;
  bool showRelocateDialog = false;
  late List<ContainerX> _containers;
  ContainerX? _selectedContainer;
  late Set<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _containers = widget._containers;
    createMarkers();
  }

  ///Fill markers with default color, at first build & no marker selected build
  void createMarkers() {
    _markers = _containers
        .map((container) =>
            container.toMarker(handleMarkerClick, _viewModel.defaultMarkerIcon))
        .toSet();
  }

  void setSelectedContainer(String id) {
    _selectedContainer =
        _containers.firstWhere((container) => container.id == id);
  }

  void changeColorOfSelectedMarker(String id) {
    var updatedMarkers = _markers
        .map(
          (marker) => marker.mapsId.value == id
              ? marker.copyWith(iconParam: _viewModel.selectedMarkerIcon)
              : marker.copyWith(iconParam: _viewModel.defaultMarkerIcon),
        )
        .toSet();

    // setState(() {
    _markers = updatedMarkers;
    // });
  }

  void handleMarkerClick(String id) {
    markerSelectionMode = true;
    setSelectedContainer(id);
    changeColorOfSelectedMarker(id);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Stack(children: [
      GoogleMap(
        onTap: (_) {
          setState(() {
            markerSelectionMode = false;
            resetMarkerIcons();
          });
        },
        markers: _markers,
        initialCameraPosition: widget._initialCameraPosition,
        // initialCameraPosition: CameraPosition(
        //     target: _viewModel.userPosition, zoom: 19),
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        // onMapCreated: (controller) =>
        //     _googleMapController = controller,
      ),
      if (markerSelectionMode) buildContainerInfoCard(textTheme),
      if (showRelocateDialog) buildRelocatiInfoCard(textTheme)
    ]);
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
                    Text('12.01.2020', style: textTheme.bodyText1),
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
                      showRelocateDialog = true;
                      setState(() {
                        showRelocateDialog = true;
                        createMarkers();
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

  void resetMarkerIcons() {
    var updatedMarkers = _markers
        .map(
          (marker) => marker.copyWith(iconParam: _viewModel.defaultMarkerIcon),
        )
        .toSet();

    // setState(() {
    _markers = updatedMarkers;
    // });
  }
}