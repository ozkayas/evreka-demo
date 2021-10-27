import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

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
    // json field names should me defined outside

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

  Map<String, dynamic> toJson() => {
        "id": id,
        "lat": lat,
        "long": long,
        "fullnessRate": fullnessRate,
        "temperature": temperature,
        "sensorId": sensorId,
        "lastDataDate": lastDataDate,
      };
}
