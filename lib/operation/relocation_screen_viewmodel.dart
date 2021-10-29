import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_map_i/models/container.dart';
import 'package:google_map_i/operation/database_service.dart';

class RelocationViewModel extends GetxController {
  /// Send Relocation request to db
  void relocateContainer(ContainerX container) {
    final DatabaseService _db = DatabaseService();

    _db.relocateContainer(
        container.id, GeoPoint(container.lat, container.long));
  }
}
