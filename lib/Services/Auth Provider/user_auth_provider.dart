import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_rider_app/Models/ride_request_model.dart';
import 'package:uber_rider_app/Models/user_model.dart';
import 'package:uber_rider_app/Services/Notifications/notifications_service.dart';

import '../../Global/constants.dart';

class AuthProvider with ChangeNotifier {
  final NotificationsService _notificationsService = NotificationsService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final ValueNotifier<UserModel?> _userModel = ValueNotifier<UserModel?>(null);
  final ValueNotifier<bool> _isUserAllowed = ValueNotifier<bool>(false);
  ValueNotifier<UserModel?> get userGetter => _userModel;
  ValueNotifier<bool> get isUserAllowedGetter => _isUserAllowed;
  UserModel? get user => _userModel.value;
  User? _user;

  late Stream<DatabaseEvent> _subscription;

  Stream<DatabaseEvent> get inProgressTripsStream => _subscription;

  Future<List<RideRequestModel?>> getCompletedTrips() async {
    try {
      final trips = await _database
          .ref()
          .child("users")
          .child(_user!.uid)
          .child("trips")
          .orderByChild("/status")
          .equalTo("RideStatus.finished")
          .once();
      log("Completed Trips: ${trips.snapshot.value}");
      final List<RideRequestModel?> tripsData = [];
      if (trips.snapshot.exists) {
        final data = trips.snapshot.value as Map;
        for (var trip in data.values) {
          final tripData = trip as Map;
          tripsData.add(
            RideRequestModel.fromMap(tripData),
          );
        }
      }
      return tripsData;
    } catch (e) {
      log("getCompletedTrips $e");
      return [];
    }
  }

  Future<List<RideRequestModel?>> getOngoingTrips() async {
    try {
      final trips = await _database
          .ref()
          .child("users")
          .child(_user!.uid)
          .child("trips")
          .once();
      List<RideRequestModel?> tripsData = [];
      if (trips.snapshot.exists) {
        final data = trips.snapshot.value as Map;
        for (var trip in data.values) {
          final tripData = trip as Map;
          if (tripData["status"] != "RideStatus.finished" ||
              tripData["status"] != "RideStatus.cancelled") {
            tripsData.add(
              RideRequestModel.fromMap(tripData),
            );
          }
        }
      }

      return tripsData;
    } catch (e) {
      log("getOngoingTrips $e");
      return [];
    }
  }

  Future<List<RideRequestModel?>> getCancelTrips() async {
    try {
      final trips = await _database
          .ref()
          .child("users")
          .child(_user!.uid)
          .child("trips")
          .orderByChild("/status")
          .equalTo("RideStatus.cancelled")
          .once();
      List<RideRequestModel?> tripsData = [];
      if (trips.snapshot.exists) {
        final data = trips.snapshot.value as Map;
        for (var trip in data.values) {
          final tripData = trip as Map;
          tripsData.add(
            RideRequestModel.fromMap(tripData),
          );
        }
      }

      return tripsData;
    } catch (e) {
      log("getCancelTrips $e");
      return [];
    }
  }

  Future<bool> getCurrentUser() async {
    final User? firebaseUser = _auth.currentUser;
    _notificationsService.init();
    if (firebaseUser != null) {
      _user = firebaseUser;
      _userModel.value = await getUserFromRealtimeDatabase();
      final token = await _notificationsService.getToken();
      saveToken(token: token);
      _notificationsService.onRefreshToken()?.listen((token) {
        saveToken(token: token);
      });
      isUserAllowed();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  FirebaseDatabase get database => _database;
  FirebaseAuth get auth => _auth;

  saveToken({String? token}) {
    try {
      if (auth.currentUser != null) {
        _database
            .ref()
            .child("users")
            .child(_user!.uid)
            .child("token")
            .set(token);
        _userModel.value = _userModel.value!.copyWith(token: token);
        _notificationsService.subscribe("allRiders");
        // _notificationsService.subscribe("allDrivers");
      }
    } catch (e) {
      log("saveToken $e");
    }
  }

  Future<bool> signUp(
      String email, String password, UserModel? usermodel) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _auth.currentUser!.updateDisplayName(usermodel?.displayName);
      _user = _auth.currentUser;
      final added = await addUserToRealtimeDatabase(
        usermodel!.copyWith(
            isVerified: auth.currentUser!.emailVerified,
            displayName: auth.currentUser!.displayName,
            uid: auth.currentUser!.uid,
            email: auth.currentUser!.email),
      );
      final token = await _notificationsService.getToken();
      saveToken(token: token);
      _notificationsService.onRefreshToken()?.listen((token) {
        saveToken(token: token);
      });

      _userModel.value = usermodel;
      isUserAllowed();

      notifyListeners();
      return added;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw ('The account already exists for that email.');
      }
    } catch (e) {
      log("signUp $e");
    }
    return false;
  }

  // Add User to realtime database
  Future<bool> addUserToRealtimeDatabase(UserModel usermodel) async {
    try {
      await _database.ref().child("users").child(_user!.uid).set(
            usermodel.toMap(),
          );
      return true;
    } catch (e) {
      log("addUserToRealtimeDatabase $e");
      return false;
    }
  }

  // Get User from realtime database
  Future<UserModel?> getUserFromRealtimeDatabase() async {
    try {
      final snapshot =
          await _database.ref().child("users").child(_user!.uid).once();
      final trips = await getTrips();

      if (snapshot.snapshot.exists) {
        final data = snapshot.snapshot.value as Map;
        _userModel.value = UserModel.fromMap({
          "uid": data["uid"],
          "email": data["email"],
          "displayName": data["displayName"],
          "fname": data['fname'],
          "lname": data['lname'],
          "isVerified": data["isVerified"],
          "phone": data["phone"],
          "isPhoneVerified": data["isPhoneVerified"],
          "token": data["token"],
          "role": data["role"],
        });
        _userModel.value?.trips = trips;
        return _userModel.value;
      } else {
        return null;
      }
    } catch (e) {
      log("getUserFromRealtimeDatabase $e");
      return null;
    }
  }

  Future<List<RideRequestModel?>?> getTrips() async {
    try {
      final trips = await _database
          .ref()
          .child("users")
          .child(_user!.uid)
          .child("trips")
          .once();
      final List<RideRequestModel?> temp = [];
      if (trips.snapshot.exists) {
        final data = trips.snapshot.value as Map;
        for (var trip in data.values) {
          final tripData = trip as Map;
          temp.add(
            RideRequestModel.fromMap(tripData),
          );
        }
      }
      return temp;
    } catch (e) {
      log("Trips $e");
      return [];
    }
  }

  // Update User to realtime database
  Future<bool> updateUserToRealtimeDatabase(UserModel usermodel) async {
    try {
      await _database.ref().child("users").child(_user!.uid).update(
            usermodel.toMap(),
          );
      return true;
    } catch (e) {
      log("Update User to Database $e");
      return false;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = _auth.currentUser;
      _userModel.value = await getUserFromRealtimeDatabase();
      isUserAllowed();
      notifyListeners();

      return _user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw ('Wrong password provided for that user.');
      }
    } catch (e) {
      log("Login $e");
      throw (e.toString());
    }
    return null;
  }

  isUserAllowed() {
    _isUserAllowed.value = _user != null &&
            _userModel.value != null &&
            _userModel.value?.phone != null &&
            _userModel.value!.isPhoneVerified!
        ? true
        : false;
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _user = null;
      _userModel.value = null;
      isUserAllowed();
      notifyListeners();
    } catch (e) {
      log("Logout $e");
    }
  }

  Future<void> getUser() async {
    try {
      _user = _auth.currentUser;
      isUserAllowed();
      notifyListeners();
    } catch (e) {
      log('Get User $e');
    }
  }

  // Update a field in the realtime database
  Future<bool> updateField(Map<String, dynamic> userData) async {
    try {
      await _database.ref().child("users").child(_user!.uid).update(userData);
      userGetter.value?.copyWith(isPhoneVerified: true);
      isUserAllowed();
      notifyListeners();
      return true;
    } catch (e) {
      log("Update Field $e");
      return false;
    }
  }

  // Update a field in the realtime database
  Future<bool> updateValue(
      Map<String, dynamic> userData, UserModel userModel) async {
    try {
      await _database.ref().child("users").child(_user!.uid).update(userData);
      userGetter.value = user?.copyWith(
        isPhoneVerified: userModel.isPhoneVerified ?? user?.isPhoneVerified,
        isVerified: userModel.isVerified ?? user?.isVerified,
        displayName: userModel.displayName ?? user?.displayName,
        email: userModel.email ?? user?.email,
        fname: userModel.fname ?? user?.fname,
        lname: userModel.lname ?? user?.lname,
        phone: userModel.phone ?? user?.phone,
        token: userModel.token ?? user?.token,
        role: userModel.role ?? user?.role,
        uid: userModel.uid ?? user?.uid,
      );
      log("User UpdateVAlue $user");
      userGetter.notifyListeners();
      isUserAllowed();
      notifyListeners();
      return true;
    } catch (e) {
      log("Update Value $e");
      return false;
    }
  }

  Future<bool> updatePassword(
      {String? currentPassword,
      required String password,
      required BuildContext context}) async {
    try {
      if (auth.currentUser != null) {
        final credential = EmailAuthProvider.credential(
            email: user!.email!, password: password);
        await auth.currentUser!.reauthenticateWithCredential(credential);
        await auth.currentUser?.updatePassword(password);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 10),
          behavior: SnackBarBehavior.floating,
          backgroundColor: SPLASH_SCREEN_COLOR,
          content: Text(
            e.message.toString(),
            style: const TextStyle(
              fontSize: 12,
              color: TXT_COLOR_ERROR,
              fontFamily: FONT_BOLT_REGULAR,
            ),
          ),
        ),
      );
      log("Update Password $e");
      return false;
    }
  }

  Future updateEmail({required String email}) async {
    try {
      if (auth.currentUser != null) {
        auth.currentUser?.updateEmail(email);
      }
    } catch (e) {
      log("Update Email $e");
    }
  }

  Future<void> sendVerificationLink() async {
    try {
      if (auth.currentUser != null) {
        await auth.currentUser!.sendEmailVerification();
      }
    } catch (e) {
      log("sendVerificationLink $e");
    }
  }
}
