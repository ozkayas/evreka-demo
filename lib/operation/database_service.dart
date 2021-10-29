import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> fetchContainers() {
    final CollectionReference containersReference =
        firestore.collection('containers');

    Stream<QuerySnapshot<Object?>> collectionStream =
        containersReference.snapshots();
    //Donen veriyi gormek icin print
    collectionStream.first.then((value) => print(value.docs.first.data()));
    return collectionStream;
  }

  void relocateContainer(String id, GeoPoint position) {
    final CollectionReference containersReference =
        firestore.collection('containers');

    containersReference.doc(id).update({"position": position});
  }
}
