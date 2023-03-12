// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uber_rider_app/Models/person_model.dart';

import 'car_model.dart';

class DriverModel {
  String? earnings;
  Person? driver;
  CarDetails? carDetails;

  DriverModel({
    this.earnings,
    this.driver,
    this.carDetails,
  });

  DriverModel copyWith({
    String? earnings,
    Person? driver,
    CarDetails? carDetails,
  }) {
    return DriverModel(
      earnings: earnings ?? this.earnings,
      driver: driver ?? this.driver,
      carDetails: carDetails ?? this.carDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'earnings': earnings,
      'driver': driver?.toMap(),
      'carDetails': carDetails?.toMap(),
    };
  }

  factory DriverModel.fromMap(Map map) {
    return DriverModel(
      earnings: map['earnings'] != null ? map['earnings'] as String : null,
      driver:
          map['driver'] != null ? Person.fromMap(map['driver'] as Map) : null,
      carDetails: map['carDetails'] != null
          ? CarDetails.fromMap(map['carDetails'] as Map)
          : null,
    );
  }

  bool isEmpty() {
    return driver?.email == null &&
        carDetails?.carNumber == null &&
        carDetails?.carModel == null &&
        carDetails?.carColor == null &&
        carDetails?.carType == null &&
        driver?.phone == null &&
        driver?.fname == null &&
        driver?.lname == null &&
        driver?.email == null &&
        driver?.fullname == null &&
        driver?.id == null &&
        driver?.isEmailVerified == null &&
        driver?.isPhoneVerified == null &&
        driver?.isPersonVerified == null &&
        driver?.role == null;
  }

  String toJson() => json.encode(toMap());

  factory DriverModel.fromJson(String source) =>
      DriverModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DriverModel(earnings: $earnings, driver: $driver, carDetails: $carDetails)';

  @override
  bool operator ==(covariant DriverModel other) {
    if (identical(this, other)) return true;

    return other.earnings == earnings &&
        other.driver == driver &&
        other.carDetails == carDetails;
  }

  @override
  int get hashCode => earnings.hashCode ^ driver.hashCode ^ carDetails.hashCode;
}
