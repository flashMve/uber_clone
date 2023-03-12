// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:uber_rider_app/Models/ride_request_model.dart';

class UserModel {
  String? uid;
  String? displayName;
  String? fname;
  String? lname;
  String? email;
  bool? isVerified;
  bool? isPhoneVerified;
  String? phone;
  String? token;
  String? role;
  List<RideRequestModel?>? trips;
  UserModel({
    this.uid,
    this.displayName,
    this.fname,
    this.lname,
    this.email,
    this.isVerified,
    this.isPhoneVerified,
    this.phone,
    this.token,
    this.role,
    this.trips,
  });

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? fname,
    String? lname,
    String? email,
    bool? isVerified,
    bool? isPhoneVerified,
    String? phone,
    String? token,
    String? role,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      fname: fname ?? this.fname,
      lname: lname ?? this.lname,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      phone: phone ?? this.phone,
      token: token ?? this.token,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'displayName': displayName,
      'fname': fname,
      'lname': lname,
      'email': email,
      'isVerified': isVerified,
      'isPhoneVerified': isPhoneVerified,
      'phone': phone,
      'token': token,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      displayName:
          map['displayName'] != null ? map['displayName'] as String : null,
      fname: map['fname'] != null ? map['fname'] as String : null,
      lname: map['lname'] != null ? map['lname'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      isVerified: map['isVerified'] != null ? map['isVerified'] as bool : null,
      isPhoneVerified: map['isPhoneVerified'] != null
          ? map['isPhoneVerified'] as bool
          : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, displayName: $displayName, fname: $fname, lname: $lname, email: $email, isVerified: $isVerified, isPhoneVerified: $isPhoneVerified, phone: $phone, token: $token, role: $role, trips: $trips)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.displayName == displayName &&
        other.fname == fname &&
        other.lname == lname &&
        other.email == email &&
        other.isVerified == isVerified &&
        other.isPhoneVerified == isPhoneVerified &&
        other.phone == phone &&
        other.token == token &&
        other.role == role &&
        listEquals(other.trips, trips);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        displayName.hashCode ^
        fname.hashCode ^
        lname.hashCode ^
        email.hashCode ^
        isVerified.hashCode ^
        isPhoneVerified.hashCode ^
        phone.hashCode ^
        token.hashCode ^
        role.hashCode ^
        trips.hashCode;
  }
}
