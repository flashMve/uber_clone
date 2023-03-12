// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Person {
  String? id;
  String? fullname;
  String? fname;
  String? lname;
  String? email;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  bool? isPersonVerified;
  String? phone;
  String? profilePic;
  String? token;
  String? role;

  Person({
    this.id,
    this.fullname,
    this.fname,
    this.lname,
    this.email,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.isPersonVerified,
    this.phone,
    this.profilePic,
    this.token,
    this.role,
  });

  Person copyWith({
    String? id,
    String? fullname,
    String? fname,
    String? lname,
    String? email,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isPersonVerified,
    String? phone,
    String? profilePic,
    String? token,
    String? role,
  }) {
    return Person(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      fname: fname ?? this.fname,
      lname: lname ?? this.lname,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isPersonVerified: isPersonVerified ?? this.isPersonVerified,
      phone: phone ?? this.phone,
      profilePic: profilePic ?? this.profilePic,
      token: token ?? this.token,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullname': fullname,
      'fname': fname,
      'lname': lname,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'isPersonVerified': isPersonVerified,
      'phone': phone,
      'profilePic': profilePic,
      'token': token,
      'role': role,
    };
  }

  factory Person.fromMap(Map map) {
    return Person(
      id: map['id'] != null ? map['id'] as String : null,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      fname: map['fname'] != null ? map['fname'] as String : null,
      lname: map['lname'] != null ? map['lname'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      isEmailVerified: map['isEmailVerified'] != null
          ? map['isEmailVerified'] as bool
          : null,
      isPhoneVerified: map['isPhoneVerified'] != null
          ? map['isPhoneVerified'] as bool
          : null,
      isPersonVerified: map['isPersonVerified'] != null
          ? map['isPersonVerified'] as bool
          : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      profilePic:
          map['profilePic'] != null ? map['profilePic'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) =>
      Person.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Person(id: $id, fullname: $fullname, fname: $fname, lname: $lname, email: $email, isEmailVerified: $isEmailVerified, isPhoneVerified: $isPhoneVerified, isPersonVerified: $isPersonVerified, phone: $phone, profilePic: $profilePic, token: $token, role: $role)';
  }

  @override
  bool operator ==(covariant Person other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullname == fullname &&
        other.fname == fname &&
        other.lname == lname &&
        other.email == email &&
        other.isEmailVerified == isEmailVerified &&
        other.isPhoneVerified == isPhoneVerified &&
        other.isPersonVerified == isPersonVerified &&
        other.phone == phone &&
        other.profilePic == profilePic &&
        other.token == token &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullname.hashCode ^
        fname.hashCode ^
        lname.hashCode ^
        email.hashCode ^
        isEmailVerified.hashCode ^
        isPhoneVerified.hashCode ^
        isPersonVerified.hashCode ^
        phone.hashCode ^
        profilePic.hashCode ^
        token.hashCode ^
        role.hashCode;
  }
}
