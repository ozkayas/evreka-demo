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

  Completer<GoogleMapController> _controller = Completer();

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
  void didChangeDependencies() {
    fillItems();
    super.didChangeDependencies();
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
    //print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('googlemap build');
    _manager.setItems(widget._containers
        .map((container) => Place(
            name: container.id, latLng: LatLng(container.lat, container.long)))
        .toList());

    return Container(
      child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _initialCameraPosition,
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _manager.setMapId(controller.mapId);
          },
          onCameraMove: _manager.onCameraMove,
          onCameraIdle: _manager.updateMap),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _manager.setItems(<Place>[
      //       for (int i = 0; i < 100; i++)
      //         Place(
      //             name: 'New Place ${DateTime.now()} $i',
      //             latLng: LatLng(48.858265 + i * 0.01, 2.350107))
      //     ]);
      //   },
      //   child: Icon(Icons.update),
      // ),
    );
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p));
          },
          icon: cluster.isMultiple
              ? await _getMarkerBitmap(cluster.isMultiple ? 125 : 100,
                  text: cluster.isMultiple ? cluster.count.toString() : null)
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
}

class Place with ClusterItem {
  final String name;
  final LatLng latLng;

  Place({required this.name, required this.latLng});

  @override
  LatLng get location => latLng;
}
