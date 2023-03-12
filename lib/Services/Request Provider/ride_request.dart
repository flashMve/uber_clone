import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_rider_app/Global/constants.dart';
import 'package:uber_rider_app/Models/driver_model.dart';
import 'package:uber_rider_app/Models/ride_request_model.dart';
import 'package:uber_rider_app/main.dart';

import '../../Models/nearby_drivers.dart';

enum RideStatus {
  pending,
  accepted,
  arrived,
  started,
  completed,
  cancelled,
  finished,
}

getColorOfRideStatus(RideStatus status) {
  switch (status) {
    case RideStatus.pending:
      return Colors.orange;
    case RideStatus.accepted:
      return Colors.green;
    case RideStatus.arrived:
      return Colors.green;
    case RideStatus.started:
      return Colors.green;
    case RideStatus.completed:
      return Colors.green;
    case RideStatus.cancelled:
      return Colors.red;
    case RideStatus.finished:
      return Colors.blue;
  }
}

class RiderRequest with ChangeNotifier {
  final _ref = FirebaseDatabase.instance.ref().child('ride_request');
  final _user = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(FirebaseAuth.instance.currentUser!.uid);
  final _activeRideId = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child("activeRide");
  DatabaseReference get activeRide => _activeRideId;
  late DatabaseReference _requestRef;
  final List<NearbyDrivers> _nearbyDrivers = [];
  bool onKeyLoaded = false;

  final ValueNotifier<int> lengthOfDriver = ValueNotifier<int>(0);

  ValueNotifier<int> get length => lengthOfDriver;

  List<NearbyDrivers> get nearbyDrivers => _nearbyDrivers;

  addNearByDriver(NearbyDrivers driver) {
    _nearbyDrivers.add(driver);
    lengthOfDriver.value = _nearbyDrivers.length;
    notifyListeners();
  }

  removeNearbyDriver({required String key}) {
    _nearbyDrivers.removeWhere((driver) => driver.key == key);
    lengthOfDriver.value = _nearbyDrivers.length;
    log(_nearbyDrivers.length.toString());

    notifyListeners();
  }

  updateNearbyDriver({required NearbyDrivers driver}) {
    final index =
        _nearbyDrivers.indexWhere((driver) => driver.key == driver.key);
    if (index > -1) {
      log("Before Hand${_nearbyDrivers[index]}");
      _nearbyDrivers[index].latitude = driver.latitude;
      _nearbyDrivers[index].longitude = driver.longitude;
      log("After Hand${_nearbyDrivers[index]}");
    } else {
      addNearByDriver(driver);
    }
    notifyListeners();
  }

  Future<bool> createRideRequest({
    required BuildContext context,
    required CarType carType,
    required double price,
  }) async {
    try {
      final RideRequestModel rideRequest = RideRequestModel();
      _requestRef = _ref.push();
      rideRequest.currentLocation =
          getAddressProvider(context).pickupAddress.value;
      rideRequest.carType = carType;
      rideRequest.price = price;
      rideRequest.paymentMethod = "cash";
      rideRequest.startTime = DateTime.now();
      rideRequest.distance =
          getAddressProvider(context).getDirectionsNotifier.value!.distance!;
      rideRequest.duration =
          getAddressProvider(context).getDirectionsNotifier.value!.duration!;
      rideRequest.destinationLocation =
          getAddressProvider(context).getDropoffAddressNotifier.value;
      rideRequest.user = getAuthProvider(context).user;
      rideRequest.status = RideStatus.pending;
      rideRequest.driverId = "waiting";
      rideRequest.driverDetails = DriverModel();
      rideRequest.id = _requestRef.key;
      await _requestRef.set(rideRequest.toMap());
      await _user.child("active").set("waiting");
      await _user.child("activeRide").set(rideRequest.id);
      return true;
    } catch (e) {
      log("In Create Ride $e");
      return false;
    }
  }

  Future<bool> cancelRide(BuildContext context) async {
    try {
      final activeId = await _activeRideId.once();
      if (activeId.snapshot.exists) {
        await _user.child("active").remove();
        await _activeRideId.remove();
        await _ref.child(activeId.snapshot.value as String).remove();
      }
      return true;
    } catch (e) {
      log("Cancel Ride $e");
      return false;
    }
  }

  String? get rideId => _requestRef.key;

  void stopGeoFire() {
    if (!kIsWeb) {
      Geofire.stopListener();
    }
  }

  List<NearbyDrivers> getNewList(List<String> expiredDriversIds) {
    List<NearbyDrivers> newList = _nearbyDrivers;
    for (var id in expiredDriversIds) {
      newList.removeWhere((item) => item.key == id);
    }

    return newList;
  }

  initGeoFire() async {
    await getAddressProvider(navigatorKey.currentContext!).getLocation();
    final pickUpLocation = getAddressProvider(navigatorKey.currentContext!)
        .getPickupAddressNotifier
        .value;
    log("Address $pickUpLocation");
    final latitude = pickUpLocation?.lat;
    final longitude = pickUpLocation?.lng;
    if (!kIsWeb) {
      final started = await Geofire.initialize("availableDrivers");
      log(started.toString());
      if (started) {
        log("Started");
        Geofire.queryAtLocation(latitude!, longitude!, 15)?.listen(
          (map) {
            log("Map Data - $map");
            if (map != null) {
              var callBack = map['callBack'];

              //latitude will be retrieved from map['latitude']
              //longitude will be retrieved from map['longitude']

              switch (callBack) {
                case Geofire.onKeyEntered:
                  log("message1");
                  final nearByDriver = NearbyDrivers.fromMap(map);
                  addNearByDriver(nearByDriver);
                  if (onKeyLoaded) {
                    log("Updated also");
                    updateAvailableDriverOnMap();
                  }
                  break;

                case Geofire.onKeyExited:
                  log("message2");
                  removeNearbyDriver(key: map["key"]);
                  updateAvailableDriverOnMap();

                  break;

                case Geofire.onKeyMoved:
                  updateNearbyDriver(driver: NearbyDrivers.fromMap(map));
                  updateAvailableDriverOnMap();
                  log("message3");

                  // Update your key's location
                  break;

                case Geofire.onGeoQueryReady:
                  log("message4");
                  onKeyLoaded = true;
                  updateAvailableDriverOnMap();
                  // All Intial Data is loaded

                  break;
              }
            }

            notifyListeners();
          },
        );
      }
    }
  }

  updateAvailableDriverOnMap() {
    if (nearbyDrivers.isEmpty) {
      log("Clearing Driver Marker ${nearbyDrivers.length}");
      getAddressProvider(navigatorKey.currentContext!).clearDriveMarker();
    }
    for (var driver in nearbyDrivers) {
      log("Near By Drivers are ${nearbyDrivers.length}");
      log("Driver Data ${driver.latitude} ${driver.longitude}");
      getAddressProvider(navigatorKey.currentContext!).setMarker(
        pos: LatLng(driver.latitude!, driver.longitude!),
        markerId: driver.key!,
        isDriver: true,
        onTap: () {},
      );
    }
    notifyListeners();
  }
}
