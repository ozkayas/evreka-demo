import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_map_i/models/container.dart';
import 'package:google_map_i/operation/database_service.dart';

class OperationScreenViewModel extends GetxController {
  final _db = DatabaseService();

  List<ContainerX> containers() {
    var containers = _db.fetchContainers();
    Stream<List<DocumentSnapshot>> containersStreamList =  containers.map((querySnapshot) => querySnapshot.docs);
  

    // document snapshottan ContainerX sinifina cevirim yapacak metot lazim
    Stream<List<ContainerX>> stream containersStreamList.map((list) => null)
  
  }
}
