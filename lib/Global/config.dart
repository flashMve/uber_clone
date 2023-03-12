import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

// ignore: constant_identifier_names
const GOOGLE_MAP_API_KEY = 'AIzaSyCoSo7B3XVqnJqjd_kuzdwa0Z-yrn-AYDs';

final rideRequestRef = FirebaseDatabase.instance.ref('ride_request');
final driverRef = FirebaseDatabase.instance.ref('drivers');

int driverTimeOut = 40;
Timer? timer;

final userActiveRide = FirebaseDatabase.instance
    .ref('users')
    .child(FirebaseAuth.instance.currentUser!.uid)
    .child('active');

final driverActiveStatus = FirebaseDatabase.instance
    .ref('drivers')
    .child(FirebaseAuth.instance.currentUser!.uid)
    .child('newRide');

StreamSubscription<Position>? locationStream;

StreamSubscription? driverLocationUpdates;
