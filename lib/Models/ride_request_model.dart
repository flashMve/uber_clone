// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uber_rider_app/Models/address.dart';
import 'package:uber_rider_app/Models/user_model.dart';
import 'package:uber_rider_app/Services/Request%20Provider/ride_request.dart';

import 'driver_model.dart';

enum CarType {
  bike,
  mini,
  uberX,
  ubergo,
  auto,
}

CarType getCarType(String type) {
  if (type == "CarType.auto") {
    return CarType.auto;
  } else if (type == "CarType.mini") {
    return CarType.mini;
  } else if (type == "CarType.uberX") {
    return CarType.uberX;
  } else if (type == "CarType.ubergo") {
    return CarType.ubergo;
  } else {
    return CarType.bike;
  }
}

getRideStatus(String status) {
  switch (status) {
    case "RideStatus.accepted":
      return RideStatus.accepted;
    case "RideStatus.cancelled":
      return RideStatus.cancelled;
    case "RideStatus.pending":
      return RideStatus.pending;
    case "RideStatus.arrived":
      return RideStatus.arrived;
    case "RideStatus.completed":
      return RideStatus.completed;
    case "RideStatus.finished":
      return RideStatus.finished;
    case "RideStatus.started":
      return RideStatus.started;
  }
}

class RideRequestModel {
  String? id;
  UserModel? user;
  CarType? carType;
  double? price;
  AddressModel? currentLocation;
  AddressModel? destinationLocation;
  AddressModel? driverLocation;
  RideStatus? status;
  String? driverId;
  String? duration;
  String? paymentMethod;
  String? distance;
  int? durationValue;
  int? distanceValue;
  DriverModel? driverDetails;
  DateTime? startTime;
  DateTime? cancelTime;
  DateTime? endTime;

  RideRequestModel({
    this.id,
    this.user,
    this.carType,
    this.price,
    this.currentLocation,
    this.destinationLocation,
    this.status,
    this.driverId,
    this.duration,
    this.distance,
    this.durationValue,
    this.driverLocation,
    this.distanceValue,
    this.paymentMethod,
    this.driverDetails,
    this.startTime,
    this.cancelTime,
    this.endTime,
  });

  RideRequestModel copyWith({
    String? id,
    UserModel? user,
    CarType? carType,
    double? price,
    AddressModel? currentLocation,
    AddressModel? destinationLocation,
    AddressModel? driverLocation,
    RideStatus? status,
    String? driverId,
    String? duration,
    String? distance,
    int? durationValue,
    int? distanceValue,
    String? paymentMethod,
    DriverModel? driverDetails,
    DateTime? startTime,
    DateTime? cancelTime,
    DateTime? endTime,
  }) {
    return RideRequestModel(
      id: id ?? this.id,
      user: user ?? this.user,
      carType: carType ?? this.carType,
      price: price ?? this.price,
      currentLocation: currentLocation ?? this.currentLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      driverLocation: driverLocation ?? this.driverLocation,
      status: status ?? this.status,
      driverId: driverId ?? this.driverId,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      durationValue: durationValue ?? this.durationValue,
      distanceValue: distanceValue ?? this.distanceValue,
      driverDetails: driverDetails ?? this.driverDetails,
      startTime: startTime ?? this.startTime,
      cancelTime: cancelTime ?? this.cancelTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user?.toMap(),
      'carType': carType?.toString(),
      'price': price,
      'currentLocation': currentLocation?.toMap(),
      'destinationLocation': destinationLocation?.toMap(),
      'driverLocation': driverLocation?.toMap(),
      'status': status?.toString(),
      'driverId': driverId,
      'paymentMethod': paymentMethod,
      'duration': duration,
      'distance': distance,
      'durationValue': durationValue,
      'distanceValue': distanceValue,
      'driverDetails': driverDetails?.toMap(),
      'startTime': startTime?.millisecondsSinceEpoch,
      'cancelTime': cancelTime?.millisecondsSinceEpoch,
      'endTime': cancelTime?.millisecondsSinceEpoch,
    };
  }

  factory RideRequestModel.fromMap(Map map) {
    return RideRequestModel(
      id: map['id'] != null ? map['id'] as String : null,
      user: map['user'] != null ? UserModel.fromMap(map['user'] as Map) : null,
      carType: getCarType(map['carType']),
      price: map['price'] != null ? map['price'] as double : null,
      currentLocation: map['currentLocation'] != null
          ? AddressModel.fromMap(map['currentLocation'] as Map)
          : null,
      destinationLocation: map['destinationLocation'] != null
          ? AddressModel.fromMap(map['destinationLocation'] as Map)
          : null,
      driverLocation: map['driverLocation'] != null
          ? AddressModel.fromMap(map['driverLocation'] as Map)
          : null,
      status: getRideStatus(map['status']),
      paymentMethod:
          map['paymentMethod'] != null ? map['paymentMethod'] as String : null,
      driverId: map['driverId'] != null ? map['driverId'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      distance: map['distance'] != null ? map['distance'] as String : null,
      durationValue:
          map['durationValue'] != null ? map['durationValue'] as int : null,
      distanceValue:
          map['distanceValue'] != null ? map['distanceValue'] as int : null,
      driverDetails: map['driverDetails'] != null
          ? DriverModel.fromMap(map['driverDetails'] as Map)
          : null,
      startTime: map['startTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int)
          : null,
      cancelTime: map['cancelTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['cancelTime'] as int)
          : null,
      endTime: map['cancelTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['cancelTime'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RideRequestModel.fromJson(String source) =>
      RideRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RideRequestModel(id: $id, user: $user, carType: $carType, price: $price, currentLocation: $currentLocation, destinationLocation: $destinationLocation, status: $status, driverId: $driverId, duration: $duration, distance: $distance, durationValue: $durationValue, distanceValue: $distanceValue, driverDetails: $driverDetails, startTime: $startTime, cancelTime: $cancelTime)';
  }

  @override
  bool operator ==(covariant RideRequestModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.carType == carType &&
        other.price == price &&
        other.currentLocation == currentLocation &&
        other.destinationLocation == destinationLocation &&
        other.status == status &&
        other.driverId == driverId &&
        other.duration == duration &&
        other.distance == distance &&
        other.durationValue == durationValue &&
        other.distanceValue == distanceValue &&
        other.driverDetails == driverDetails &&
        other.startTime == startTime &&
        other.cancelTime == cancelTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        carType.hashCode ^
        price.hashCode ^
        currentLocation.hashCode ^
        destinationLocation.hashCode ^
        status.hashCode ^
        driverId.hashCode ^
        duration.hashCode ^
        distance.hashCode ^
        durationValue.hashCode ^
        distanceValue.hashCode ^
        driverDetails.hashCode ^
        startTime.hashCode ^
        cancelTime.hashCode;
  }
}
