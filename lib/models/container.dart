import 'dart:convert';

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

  factory ContainerX.fromJson(Map<String, dynamic> json) => ContainerX(
        id: json["id"],
        lat: json["lat"].toDouble(),
        long: json["long"].toDouble(),
        fullnessRate: json["fullnessRate"].toDouble(),
        temperature: json["temperature"],
        sensorId: json["sensorId"],
        lastDataDate: json["lastDataDate"],
      );

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
