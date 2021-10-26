import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> fetchContainers() {
    final CollectionReference containersReference =
        firestore.collection('containers');

    Stream<QuerySnapshot<Object?>> collectionStream =
        containersReference.snapshots();
    return collectionStream;
  }
}
