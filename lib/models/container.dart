import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

ContainerX containerXFromJson(String str) =>
    ContainerX.fromJson(json.decode(str));

String containerXToJson(ContainerX data) => json.encode(data.toJson());

class ContainerX {
  ContainerX({
    required this.id,
    required this.lat,
    required this.long,
    required this.fullnessRate,
    required this.temperature,
    required this.sensorId,
    required this.lastDataDate,
  });

  String id;
  double lat;
  double long;
  double fullnessRate;
  int temperature;
  String sensorId;
  int lastDataDate;

  factory ContainerX.fromJson(Map<String, dynamic> json) {
    // json field names should be defined outside

    GeoPoint _position = json['position'];
    Timestamp _timestamp = json['lastDataDate'];

    return ContainerX(
      id: json["id"],
      lat: _position.latitude,
      long: _position.longitude,
      fullnessRate: json["fullnessRate"].toDouble(),
      temperature: json["temperature"],
      sensorId: json["sensorId"],
      lastDataDate: _timestamp.millisecondsSinceEpoch,
    );
  }

  Marker toMarker(Function onTap, BitmapDescriptor? icon) => Marker(
      markerId: MarkerId(this.id),
      //infoWindow: InfoWindow(title: this.id),
      icon: icon ?? BitmapDescriptor.defaultMarker,
      position: LatLng(this.lat, this.long),
      onTap: () {
        onTap(this.id);
      });

  Map<String, dynamic> toJson() => {
        "id": id,
        //"lat": lat,
        //"long": long,
        "position": GeoPoint(lat, long),
        "fullnessRate": fullnessRate,
        "temperature": temperature,
        "sensorId": sensorId,
        "lastDataDate": Timestamp.fromMillisecondsSinceEpoch(lastDataDate),
      };
}
