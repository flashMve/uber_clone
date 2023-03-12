import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctions {
  FirebaseFunctions? _functions;

  FirebaseFunctions? get instance => _functions;

  CloudFunctions() {
    _functions = FirebaseFunctions.instance;
  }

  Future<Map<String, dynamic>> checkIfRiderOrDriver(
      String email, String role) async {
    final HttpsCallable callable =
        instance!.httpsCallable('checkIfRiderOrDriver');
    final result =
        await callable.call(<String, dynamic>{'email': email, "role": role});
    log("User Data ${result.data}");
    return result.data;
  }

  Future<Map<String, dynamic>> checkIfPhoneExists(String phone) async {
    final HttpsCallable callable =
        instance!.httpsCallable('checkIfPhoneExists');
    final result = await callable.call(<String, dynamic>{'phone': phone});
    log("Phone Exists ${result.data}");
    return result.data;
  }

  notifyDriver({String? driverId, String? rideId}) async {
    final HttpsCallable callable = instance!.httpsCallable('notifyDriver');
    await callable.call(<String, dynamic>{'uid': driverId, "rideId": rideId});
    log("Notify Driver ");
  }

  Future<Map<String, dynamic>> updateDriverStatus(
      {String? driverId, String? status}) async {
    final HttpsCallable callable =
        instance!.httpsCallable('updateDriverStatus');
    final result = await callable
        .call(<String, dynamic>{'uid': driverId, "status": status});
    log("updateDriverStatus ${result.data}");
    return result.data;
  }

  Future<Map<String, dynamic>> updateDriverRating(
      {String? driverId, String? rideId, double? rating}) async {
    final HttpsCallable callable =
        instance!.httpsCallable('updateDriverRating');
    final result = await callable.call(
        <String, dynamic>{'uid': driverId, "rideId": rideId, "rating": rating});
    log("updateDriverRating ${result.data}");
    return result.data;
  }
}
