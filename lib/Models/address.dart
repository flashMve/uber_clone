import 'dart:convert';

class AddressModel {
  String? id;
  double? lat;
  double? lng;
  String? address;
  String? placeid;

  AddressModel({
    this.id,
    this.lat,
    this.lng,
    this.address,
    this.placeid,
  });

  AddressModel copyWith({
    String? id,
    double? lat,
    double? lng,
    String? address,
    String? placeid,
  }) {
    return AddressModel(
      id: id ?? this.id,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
      placeid: placeid ?? this.placeid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lat': lat,
      'lng': lng,
      'address': address,
      'placeid': placeid,
    };
  }

  factory AddressModel.fromMap(Map map) {
    return AddressModel(
      id: map['id'],
      lat: map['lat']?.toDouble(),
      lng: map['lng']?.toDouble(),
      address: map['address'],
      placeid: map['placeid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddressModel(id: $id, lat: $lat, lng: $lng, address: $address, placeid: $placeid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressModel &&
        other.id == id &&
        other.lat == lat &&
        other.lng == lng &&
        other.address == address &&
        other.placeid == placeid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lat.hashCode ^
        lng.hashCode ^
        address.hashCode ^
        placeid.hashCode;
  }
}
