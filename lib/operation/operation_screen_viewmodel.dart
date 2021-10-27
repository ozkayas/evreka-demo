import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_map_i/models/container.dart';
import 'package:google_map_i/operation/database_service.dart';

class OperationScreenViewModel extends GetxController {
  final _db = DatabaseService();

  Stream<List<ContainerX>> containers() {
    var containers = _db.fetchContainers();
    Stream<List<DocumentSnapshot>> streamListDocumentSnapshot =
        containers.map((querySnapshot) => querySnapshot.docs);

    // document snapshottan ContainerX sinifina cevirim yapacak metot lazim
    Stream<List<ContainerX>> streamListContainer = streamListDocumentSnapshot
        .map((listDocumentSnapshot) => listDocumentSnapshot
            .map((documentSnapshot) =>
                ContainerX.fromJson(documentSnapshot as Map<String, dynamic>))
            .toList());

    return streamListContainer;
  }
}
