import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:uber_rider_app/Global/config.dart';
import 'package:uber_rider_app/Screens/Home%20Screens/ride_selection_list.dart';
import 'package:uber_rider_app/Services/Data%20Provider/cloud_functions.dart';

import '../../Global/constants.dart';
import '../../Models/car_model.dart';
import '../../Models/nearby_drivers.dart';
import '../../Models/ride_request_model.dart';
import '../../main.dart';
import '../Splash Screen/fade_animation.dart';

class RideSelectionPanel extends StatefulWidget {
  const RideSelectionPanel({
    Key? key,
    required this.resetApp,
    required this.isRequesting,
  }) : super(key: key);

  final Function resetApp;
  final bool isRequesting;

  @override
  State<RideSelectionPanel> createState() => _RideSelectionPanelState();
}

class _RideSelectionPanelState extends State<RideSelectionPanel> {
  final ValueNotifier<bool> isRquested = ValueNotifier(false);

  final ValueNotifier<bool> isFull = ValueNotifier(false);

  final ValueNotifier<bool> driversAvailable = ValueNotifier(true);
  List<String> expiredDriversIds = [];
  String? currentdriversId = "";
  List<NearbyDrivers> availableDrivers =
      getRiderRequest(navigatorKey.currentContext!).nearbyDrivers;

  searchNearbyDriver(CarType carType) {
    if (availableDrivers.isEmpty) {
      driversAvailable.value = false;
      resetTimer();
      widget.resetApp(context);
      getRiderRequest(context).cancelRide(context);
      showSnackBar(message: "No Drivers Found");
      return;
    }

    final driver = availableDrivers.first;
    driverRef.child(driver.key!).child("carDetails").once().then((carDetail) {
      final carDetails = CarDetails.fromMap(carDetail.snapshot.value as Map);
      if (carDetails.carType == carType) {
        notifyDriver(driver, carType);
        currentdriversId = driver.key;
        expiredDriversIds.add(driver.key!);
        availableDrivers.removeAt(0);
      } else {
        driversAvailable.value = false;
        resetTimer();
        widget.resetApp(context);
        getRiderRequest(context).cancelRide(context);
        showSnackBar(message: "No ${getCarName(carType)} Drivers Found");
      }
    });
  }

  getCarName(CarType car) {
    switch (car) {
      case CarType.uberX:
        return "Uber X";
      case CarType.ubergo:
        return "Uber Go";
      case CarType.auto:
        return "Uber Auto";
      case CarType.bike:
        return "Uber Bike";
      case CarType.mini:
        return "Uber Mini";
      default:
        return "";
    }
  }

  notifyDriver(NearbyDrivers driver, CarType carType) {
    CloudFunctions().notifyDriver(
      driverId: driver.key,
      rideId: getRiderRequest(navigatorKey.currentContext!).rideId,
    );
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      driverTimeOut -= 1;

      if (driverTimeOut == 0) {
        timer.cancel();
        CloudFunctions().updateDriverStatus(
          driverId: driver.key,
          status: "timeout",
        );
        driverTimeOut = 40;
        searchNearbyDriver(carType);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (availableDrivers.isEmpty) {
      driversAvailable.value = false;
    }
    if (widget.isRequesting) {
      isRquested.value = true;
    }
    if (mounted) {
      getRiderRequest(navigatorKey.currentContext!).length.addListener(() {
        if (mounted) {
          if (getRiderRequest(navigatorKey.currentContext!).length.value == 0) {
            if (mounted) {
              driversAvailable.value = false;
            }
          } else {
            if (mounted) {
              driversAvailable.value = true;
              availableDrivers = getRiderRequest(navigatorKey.currentContext!)
                  .getNewList(expiredDriversIds);
            }
          }
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    getRiderRequest(navigatorKey.currentContext!).length.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    log("Near by Drivers are $availableDrivers");
    return StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref("fares").onValue,
        builder: (context, snapshot) {
          Object? data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: CONTAINER_COLOR_DARK.withOpacity(0.1),
              child: Center(
                child: LoadingBouncingGrid.square(
                  backgroundColor: CONTAINER_COLOR_DARK,
                  size: 25,
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            data = snapshot.data?.snapshot.value;

            return ValueListenableBuilder<bool>(
                valueListenable: isRquested,
                builder: (ctx, isRideRequested, __) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    minChildSize: 0.5,
                    maxChildSize: isRideRequested ? 0.5 : 1,
                    snap: true,
                    builder: (ctx, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: CONTAINER_COLOR_LIGHT,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              spreadRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: isRideRequested
                            ? FindingDriversPanel(
                                isFull: isFull,
                                isRquested: isRquested,
                                scrollController: scrollController,
                                driverId: currentdriversId,
                                resetApp: widget.resetApp,
                              )
                            : ValueListenableBuilder<bool>(
                                valueListenable: driversAvailable,
                                builder: (context, areAvailable, __) {
                                  log("Near by Drivers are ${availableDrivers.length}");

                                  return FadeAnimationChild(
                                    prop: AniProps.opacity,
                                    child: Column(
                                      children: [
                                        ValueListenableBuilder<bool>(
                                            valueListenable: isFull,
                                            builder:
                                                (context, isFullScreen, __) {
                                              if (areAvailable) {
                                                return isFullScreen
                                                    ? FadeAnimationChild(
                                                        prop: AniProps.opacity,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6),
                                                          decoration:
                                                              const BoxDecoration(
                                                            color:
                                                                CONTAINER_COLOR_DARK,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                FontAwesomeIcons
                                                                    .arrowDown,
                                                                color:
                                                                    ICON_COLOR_LIGHT,
                                                                size: 14,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Scroll Down",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      TXT_COLOR_LIGHT,
                                                                  fontFamily:
                                                                      FONT_BOLT_BOLD,
                                                                  fontSize:
                                                                      FONT_SIZE_16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox();
                                              }
                                              return const SizedBox();
                                            }),
                                        if (areAvailable)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: Text(
                                              "Choose your ride",
                                              style: TextStyle(
                                                color: TXT_COLOR_DARK,
                                                fontFamily: FONT_BOLT_BOLD,
                                                fontSize: FONT_SIZE_18,
                                              ),
                                            ),
                                          ),
                                        if (areAvailable)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8,
                                                right: 8,
                                                bottom: 8),
                                            child: Text(
                                              (data as Map)["message"] ??
                                                  "Enjoy your ride",
                                              style: TextStyle(
                                                color: TXT_COLOR_GREY.shade500,
                                                fontFamily: FONT_BOLT_REGULAR,
                                                fontSize: FONT_SIZE_14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        RideSelectionList(
                                          scrollController: scrollController,
                                          data: data,
                                          isFull: isFull,
                                          isRequested: isRquested,
                                          driversAvailable: driversAvailable,
                                          searchNearbyDrivers:
                                              searchNearbyDriver,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                      );
                    },
                  );
                });
          } else {
            return Container(
              color: CONTAINER_COLOR_DARK.withOpacity(0.1),
              child: Center(
                child: Text(
                  "No Rides Available",
                  style: TextStyle(
                    color: TXT_COLOR_DARK,
                    fontFamily: FONT_BOLT_BOLD,
                    fontSize: FONT_SIZE_16,
                  ),
                ),
              ),
            );
          }
        });
  }
}

class FindingDriversPanel extends StatelessWidget {
  const FindingDriversPanel({
    Key? key,
    required this.isFull,
    required this.isRquested,
    required this.scrollController,
    required this.driverId,
    required this.resetApp,
  }) : super(key: key);

  final ValueNotifier<bool> isFull;
  final ValueNotifier<bool> isRquested;
  final ScrollController scrollController;
  final String? driverId;
  final Function resetApp;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: FadeAnimationChild(
        prop: AniProps.opacity,
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: getSize(context).height * 0.1,
              ),
              LoadingBouncingGrid.square(
                backgroundColor: SPLASH_SCREEN_COLOR,
                size: 25,
              ),
              const SizedBox(height: 30),
              Text(
                "Finding a Ride for you...",
                style: TextStyle(
                  color: TXT_COLOR_DARK,
                  fontFamily: FONT_BOLT_BOLD,
                  fontSize: FONT_SIZE_16,
                ),
              ),
              const SizedBox(height: 30),
              TextButton.icon(
                onPressed: () async {
                  showLoadingDialog(context);
                  resetTimer();

                  CloudFunctions()
                      .updateDriverStatus(
                    driverId: driverId,
                    status: "cancelled",
                  )
                      .then((value) {
                    getRiderRequest(context).cancelRide(context).then(
                      (value) {
                        pop(context);
                        isFull.value = false;
                        isRquested.value = false;
                        resetApp(context);
                      },
                    );
                  });
                },
                icon: Icon(
                  FontAwesomeIcons.xmark,
                  color: ICON_COLOR_ERROR.shade900,
                  size: 20,
                ),
                label: Text(
                  "Cancel Ride",
                  style: TextStyle(
                    color: TXT_COLOR_ERROR.shade900,
                    fontFamily: FONT_BOLT_REGULAR,
                    fontSize: FONT_SIZE_16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
