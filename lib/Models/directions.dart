import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  LatLngBounds? bounds;
  List<PointLatLng>? points;
  String? duration;
  String? distance;
  int? durationValue;
  int? distanceValue;

  Directions({
    this.bounds,
    this.points,
    this.duration,
    this.distance,
    this.durationValue,
    this.distanceValue,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    PolylinePoints polylinePoints = PolylinePoints();
    if ((map["routes"] as List).isEmpty) return Directions();

    // Get Route information
    final data = Map<String, dynamic>.from(map["routes"][0]);
    final northeast = data["bounds"]["northeast"];
    final southwest = data["bounds"]["southwest"];
    final bounds = LatLngBounds(
        southwest: LatLng(southwest["lat"], southwest["lng"]),
        northeast: LatLng(northeast["lat"], northeast["lng"]));
    final points =
        polylinePoints.decodePolyline(data['overview_polyline']['points']);
    final legs = (data['legs'][0] as Map<String, dynamic>);
    final duration = legs['duration']['text'] as String;
    final distance = legs['distance']['text'] as String;
    final durationValue = legs['duration']['value'] as int;
    final distanceValue = legs['distance']['value'] as int;

    return Directions(
      bounds: bounds,
      distance: distance,
      distanceValue: distanceValue,
      duration: duration,
      durationValue: durationValue,
      points: points,
    );
  }
}
