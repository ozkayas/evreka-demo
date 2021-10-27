import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_map_i/models/container.dart';
import 'package:google_map_i/operation/database_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OperationScreenViewModel extends GetxController {
  final _db = DatabaseService();

  Stream<List<ContainerX>> containers() {
    var containers = _db.fetchContainers();

    ///Stream<QuerySnapshot> ==> Stream<List<DocumentSnaphot>>
    Stream<List<DocumentSnapshot>> streamListDocumentSnapshot =
        containers.map((querySnapshot) => querySnapshot.docs);

    streamListDocumentSnapshot.first
        .then((value) => print('value = ${value.first['id']}'));

    ///tream<List<DocumentSnaphot>> ==> Stream<List<ContainerX>>
    var streamListContainer = streamListDocumentSnapshot.map(
        (listDocumentSnapshot) => listDocumentSnapshot
            .map((documentSnapshot) => ContainerX.fromJson(
                documentSnapshot.data() as Map<String, dynamic>))
            .toList());

    streamListContainer.first
        .then((value) => print('first container ${value.first}'));

    return streamListContainer;
  }

  Stream<List<Marker>> streamOfMarkers() {
    var containers = _db.fetchContainers();

    ///Stream<QuerySnapshot> ==> Stream<List<DocumentSnaphot>>
    Stream<List<DocumentSnapshot>> streamListDocumentSnapshot =
        containers.map((querySnapshot) => querySnapshot.docs);

    ///tream<List<DocumentSnaphot>> ==> Stream<List<Marker>>
    var streamListMarker = streamListDocumentSnapshot.map(
        (listDocumentSnapshot) => listDocumentSnapshot
            .map((documentSnapshot) => ContainerX.fromJson(
                    documentSnapshot.data() as Map<String, dynamic>)
                .toMarker())
            .toList());

    return streamListMarker;
  }
}
