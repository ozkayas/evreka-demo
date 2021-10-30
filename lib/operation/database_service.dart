import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_map_i/models/container.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> fetchContainers() {
    final CollectionReference containersReference =
        firestore.collection('containers');

    Stream<QuerySnapshot<Object?>> collectionStream =
        containersReference.snapshots();
    //Donen veriyi gormek icin print
    //collectionStream.first.then((value) => print(value.docs.first.data()));
    return collectionStream;
  }

  void relocateContainer(String id, GeoPoint position) {
    final CollectionReference containersReference =
        firestore.collection('containers');

    containersReference.doc(id).update({"position": position});
  }

  var container = ContainerX(
      id: 'deneme',
      lat: 38,
      long: 27,
      fullnessRate: 1,
      temperature: 20,
      sensorId: 'abc',
      lastDataDate: DateTime.now().millisecondsSinceEpoch);

  void addContainer() {
    final CollectionReference containersReference =
        firestore.collection('containers');

    var containersToAdd = createRandomContainers(100);

    containersToAdd.forEach((container) {
      containersReference.doc(container.id).set(container.toJson());
    });
  }

  List<ContainerX> createRandomContainers(int n) {
    List<ContainerX> list = [];
    var minLat = 38.477;
    var maxLat = 38.550;
    var minLong = 27.030;
    var maxLong = 27.215;

    double doubleInRange(num start, num end) =>
        Random().nextDouble() * (end - start) + start;

    String generateRandomString(int len) {
      var r = Random();
      const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
      return 'Container ' +
          List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
              .join();
    }

    for (var i = 0; i < n; i++) {
      list.add(ContainerX(
          id: generateRandomString(7),
          lat: doubleInRange(minLat, maxLat),
          long: doubleInRange(minLong, maxLong),
          fullnessRate: double.parse((doubleInRange(0, 1).toStringAsFixed(2))),
          temperature: 20,
          sensorId: 'Sensor No: 12',
          lastDataDate: DateTime.now().millisecondsSinceEpoch));
    }
    return list;
  }
}
