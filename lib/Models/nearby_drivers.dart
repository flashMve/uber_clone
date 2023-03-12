// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NearbyDrivers {
  String? key;
  double? latitude;
  double? longitude;

  NearbyDrivers({
    this.key,
    this.latitude,
    this.longitude,
  });

  NearbyDrivers copyWith({
    String? key,
    double? latitude,
    double? longitude,
  }) {
    return NearbyDrivers(
      key: key ?? this.key,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory NearbyDrivers.fromMap(Map map) {
    return NearbyDrivers(
      key: map['key'] != null ? map['key'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NearbyDrivers.fromJson(String source) =>
      NearbyDrivers.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'NearbyDrivers(key: $key, latitude: $latitude, longitude: $longitude)';

  @override
  bool operator ==(covariant NearbyDrivers other) {
    if (identical(this, other)) return true;

    return other.key == key &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => key.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
