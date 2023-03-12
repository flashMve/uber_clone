import 'dart:convert';

import 'package:uber_rider_app/Models/ride_request_model.dart';

class CarDetails {
  String? carName;
  String? carNumber;
  String? carColor;
  String? carModel;
  CarType? carType;

  CarDetails({
    this.carName,
    this.carNumber,
    this.carColor,
    this.carModel,
    this.carType,
  });

  CarDetails copyWith({
    String? carName,
    String? carNumber,
    String? carColor,
    String? carModel,
    CarType? carType,
  }) {
    return CarDetails(
      carName: carName ?? this.carName,
      carNumber: carNumber ?? this.carNumber,
      carColor: carColor ?? this.carColor,
      carModel: carModel ?? this.carModel,
      carType: carType ?? this.carType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'carName': carName,
      'carNumber': carNumber,
      'carColor': carColor,
      'carModel': carModel,
      'carType': carType.toString(),
    };
  }

  factory CarDetails.fromMap(Map map) {
    return CarDetails(
      carName: map['carName'] != null ? map['carName'] as String : null,
      carNumber: map['carNumber'] != null ? map['carNumber'] as String : null,
      carColor: map['carColor'] != null ? map['carColor'] as String : null,
      carModel: map['carModel'] != null ? map['carModel'] as String : null,
      carType: getCarType(map['carType']),
    );
  }

  bool isEmpty() {
    return carName == null &&
        carNumber == null &&
        carColor == null &&
        carModel == null &&
        carType == null;
  }

  String toJson() => json.encode(toMap());

  factory CarDetails.fromJson(String source) =>
      CarDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarDetails(carName: $carName, carNumber: $carNumber, carColor: $carColor, carModel: $carModel, carType: $carType)';
  }

  @override
  bool operator ==(covariant CarDetails other) {
    if (identical(this, other)) return true;

    return other.carName == carName &&
        other.carNumber == carNumber &&
        other.carColor == carColor &&
        other.carModel == carModel &&
        other.carType == carType;
  }

  @override
  int get hashCode {
    return carName.hashCode ^
        carNumber.hashCode ^
        carColor.hashCode ^
        carModel.hashCode ^
        carType.hashCode;
  }
}
