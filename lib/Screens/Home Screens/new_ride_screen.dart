import 'dart:async';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_rider_app/Global/config.dart';
import 'package:uber_rider_app/Services/Request%20Provider/ride_request.dart';
import 'package:uber_rider_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Global/constants.dart';
import '../../Models/ride_request_model.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/divider.dart';
import '../page.dart';
import 'Ride Screen/pay_cash_dialog.dart';

class UserRideScreen extends StatefulWidget {
  final String rideId;
  const UserRideScreen({
    Key? key,
    required this.rideId,
  }) : super(key: key);

  @override
  State<UserRideScreen> createState() => _UserRideScreenState();
}

class _UserRideScreenState extends State<UserRideScreen> {
  late Stream<LatLng> driverLocation;

  CustomInfoWindowController controller = CustomInfoWindowController();
  late StreamSubscription<DatabaseEvent> details;
  late RideRequestModel rideDetails;

  bool isLoading = true;
  bool isDialogShown = false;

  @override
  void initState() {
    super.initState();
    getRiderRequest(context).stopGeoFire();
    driverLocation = rideRequestRef
        .child(widget.rideId)
        .child("driverLocation")
        .onValue
        .map((event) {
      final location = event.snapshot.value as Map;
      return LatLng(location["latitude"], location["longitude"]);
    });
    details = rideRequestRef.child(widget.rideId).onValue.listen((snapshot) {
      if (snapshot.snapshot.exists) {
        final rideRequest = snapshot.snapshot.value as Map;
        rideDetails = RideRequestModel.fromMap(rideRequest);
        if (rideDetails.status == RideStatus.completed && !isDialogShown) {
          isDialogShown = true;
          AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: navigatorKey.currentContext!,
            barrierColor: CONTAINER_COLOR_DARK.withOpacity(0.4),
            animType: AnimType.TOPSLIDE,
            dialogType: DialogType.NO_HEADER,
            dialogBorderRadius: BorderRadius.circular(4),
            customHeader: const Icon(
              FontAwesomeIcons.moneyBill1Wave,
              size: 40,
              color: CONTAINER_COLOR_ONLINE,
            ),
            body: PayCash(
              driverId: rideDetails.driverId!,
              cash: rideDetails.price!.toString(),
              paymentMethod: rideDetails.paymentMethod!,
              rideId: rideDetails.id!,
            ),
            btnOk: null,
            padding: const EdgeInsets.all(0),
            btnCancel: null,
          ).show();
        }
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    details.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showSnackBar(
            message:
                "You cannot go back from this page. Unity is a one-way trip.",
            time: 5);
        return false;
      },
      child: SafeAreaScreen(
        child: isLoading
            ? Scaffold(
                backgroundColor: getBackgroundColor(context),
                body: Center(
                  child: LoadingBouncingGrid.square(
                    backgroundColor: SPLASH_SCREEN_COLOR,
                    size: 25,
                  ),
                ),
              )
            : Scaffold(
                bottomSheet: Container(
                    height: getSize(context).height * 0.57,
                    width: getSize(context).width,
                    decoration: const BoxDecoration(
                      color: Color(0xffFAF9F6),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                        topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 4000,
                          spreadRadius: 3,
                          offset: Offset(-7, -7),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 4,
                                      width: 50,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(top: 8),
                                      decoration: BoxDecoration(
                                        color: CONTAINER_COLOR_DARK
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      rideDetails.status == RideStatus.accepted
                                          ? "Your Ride will be here in ${rideDetails.duration}"
                                              .toUpperCase()
                                          : rideDetails.status ==
                                                  RideStatus.arrived
                                              ? "Your ride is here."
                                              : rideDetails.status ==
                                                      RideStatus.started
                                                  ? "Will be at Destination in about ${rideDetails.duration}"
                                                      .toUpperCase()
                                                  : rideDetails.status ==
                                                          RideStatus.completed
                                                      ? "Trip Completed"
                                                      : 'Trip Ended',
                                      style: TextStyle(
                                        fontSize: FONT_SIZE_16,
                                        color: CONTAINER_COLOR_DARK,
                                        fontFamily: FONT_BOLT_BOLD,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),

                                CustomDivider(
                                  indent: 0,
                                  endIndent: 0,
                                  color: CONTAINER_COLOR_GREY.shade200,
                                  height: 20,
                                  thickness: 1,
                                ),
                                ListTile(
                                  leading: Container(
                                    height: 40,
                                    width: 40,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: CONTAINER_COLOR_GREY.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.asset(
                                      "assets/images/user_icon.png",
                                    ),
                                  ),
                                  title: Text(
                                    "${rideDetails.driverDetails?.driver?.fullname}",
                                    style: TextStyle(
                                      fontSize: FONT_SIZE_16,
                                      color: CONTAINER_COLOR_DARK,
                                      fontFamily: FONT_BOLT_BOLD,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        rideDetails.driverDetails!.carDetails!
                                            .carColor!,
                                        style: TextStyle(
                                          fontSize: FONT_SIZE_14,
                                          color: CONTAINER_COLOR_GREY.shade400,
                                          fontFamily: FONT_BOLT_REGULAR,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        " ${rideDetails.driverDetails!.carDetails!.carName!.toUpperCase()}",
                                        style: TextStyle(
                                          fontSize: FONT_SIZE_14,
                                          color: CONTAINER_COLOR_DARK,
                                          fontFamily: FONT_BOLT_BOLD,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Car Number",
                                        style: TextStyle(
                                          fontSize: FONT_SIZE_14,
                                          color: CONTAINER_COLOR_GREY.shade400,
                                          fontFamily: FONT_BOLT_BOLD,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        rideDetails.driverDetails!.carDetails!
                                            .carNumber!,
                                        style: TextStyle(
                                          fontSize: FONT_SIZE_14,
                                          color: CONTAINER_COLOR_DARK,
                                          fontFamily: FONT_BOLT_BOLD,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CustomDivider(
                                  indent: 0,
                                  endIndent: 0,
                                  color: CONTAINER_COLOR_GREY.shade200,
                                  height: 10,
                                  thickness: 1,
                                ),
                                tripDetails(rideDetails),
                                CustomDivider(
                                  indent: 0,
                                  endIndent: 0,
                                  color: CONTAINER_COLOR_GREY.shade200,
                                  height: 20,
                                  thickness: 1,
                                ),
                                // Tooltip(
                                //   message: "Call Driver",
                                //   decoration: BoxDecoration(
                                //     color: CONTAINER_COLOR_DARK,
                                //     borderRadius: BorderRadius.circular(10),
                                //   ),
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //       color: CONTAINER_COLOR_GREY.shade200,
                                //       borderRadius: BorderRadius.circular(10),
                                //     ),
                                //     child: IconButton(
                                //       onPressed: () {

                                //       },
                                //       icon: const Icon(
                                //         FontAwesomeIcons.phone,
                                //         color: SPLASH_SCREEN_COLOR,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        NonFlexUberButton(
                          onPressed: () {},
                          text: getButtonStatus(rideDetails.status!),
                          backGroundColor: getButtonColor(rideDetails.status!),
                        ),
                      ],
                    )),
                floatingActionButton: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      _launchUrl(Uri.parse(
                          "tel:${rideDetails.driverDetails!.driver?.phone}"));
                    },
                    tooltip: "Call Driver",
                    isExtended: true,
                    backgroundColor: CONTAINER_COLOR_ONLINE,
                    label: const Icon(
                      FontAwesomeIcons.phone,
                    ),
                  ),
                ),
                body: SizedBox(
                  height: getSize(context).height * 0.4,
                  child: Stack(
                    children: [
                      GoogleMapsWidget(
                        defaultCameraZoom: 19,
                        apiKey: GOOGLE_MAP_API_KEY,
                        sourceLatLng: LatLng(rideDetails.currentLocation!.lat!,
                            rideDetails.currentLocation!.lng!),
                        destinationLatLng: LatLng(
                            rideDetails.destinationLocation!.lat!,
                            rideDetails.destinationLocation!.lng!),
                        routeWidth: 5,
                        routeColor: Colors.blue,
                        sourceMarkerIconInfo: const MarkerIconInfo(
                          assetPath: "assets/images/map_icon_blue.png",
                          assetMarkerSize: Size(55, 55),
                        ),
                        destinationMarkerIconInfo: const MarkerIconInfo(
                          assetPath: "assets/images/map_icon_black.png",
                          assetMarkerSize: Size(55, 55),
                        ),
                        driverMarkerIconInfo: const MarkerIconInfo(
                          assetPath: "assets/images/car.png",
                          assetMarkerSize: Size(55, 100),
                          rotation: 15.0,
                        ),
                        driverCoordinatesStream: driverLocation,
                        updatePolylinesOnDriverLocUpdate: true,
                        sourceName: rideDetails.currentLocation!.address!,
                        destinationName:
                            rideDetails.destinationLocation!.address!,
                        driverName:
                            rideDetails.driverDetails!.driver!.fullname!,
                        totalTimeCallback: (time) => log(time.toString()),
                        totalDistanceCallback: (distance) =>
                            log(distance.toString()),
                        gestureRecognizers: <
                            Factory<OneSequenceGestureRecognizer>>{
                          Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                          ),
                        },
                        onCameraMove: (pos) {
                          controller.onCameraMove!();
                        },
                        onMapCreated: (GoogleMapController mapController) {
                          controller.googleMapController = mapController;
                        },
                        onTap: (latLng) {
                          if (controller.hideInfoWindow != null) {
                            controller.hideInfoWindow!();
                          }
                        },
                      ),
                      CustomInfoWindow(
                        controller: controller,
                        height: 30,
                        width: getSize(context).width,
                        offset: 50,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  getButtonStatus(RideStatus status) {
    switch (status) {
      case RideStatus.accepted:
        return "Arriving";
      case RideStatus.arrived:
        return "Arrived";
      case RideStatus.started:
        return "Started";
      case RideStatus.completed:
        return "Finished";
      case RideStatus.finished:
        return "Trip Ended";
      case RideStatus.cancelled:
        return "Cancelled";
      default:
        return "";
    }
  }

  getButtonColor(RideStatus status) {
    switch (status) {
      case RideStatus.accepted:
        return Colors.green;
      case RideStatus.arrived:
        return Colors.green;
      case RideStatus.started:
        return Colors.blue;
      case RideStatus.completed:
        return Colors.black;
      case RideStatus.finished:
        return Colors.black;
      case RideStatus.cancelled:
        return CONTAINER_COLOR_OFFLINE;
      default:
        return CONTAINER_COLOR_DARK;
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Container tripDetails(RideRequestModel rideDetails) {
    return Container(
      alignment: Alignment.centerLeft,
      width: getSize(navigatorKey.currentContext!).width,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TRIP",
            style: TextStyle(
              fontSize: FONT_SIZE_16,
              color: CONTAINER_COLOR_DARK,
              fontFamily: FONT_BOLT_BOLD,
            ),
          ),
          SizedBox(height: 1.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addressWidget(
                address: rideDetails.currentLocation!.address,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                ),
                child: iconWidget(),
              ),
              addressWidget(
                address: rideDetails.destinationLocation!.address,
                isDropOff: true,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget addressWidget({
    String? address = "San Francisco ",
    bool isDropOff = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        isDropOff
            ? Image.asset(MAP_ICON_BLACK, height: 5.h, width: 5.w)
            : Image.asset(MAP_ICON_BLUE, height: 5.h, width: 5.w),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            address!,
            style: TextStyle(
              fontSize: FONT_SIZE_16 - 1,
              color: CONTAINER_COLOR_DARK,
              fontFamily: FONT_BOLT_BOLD,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Column iconWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < 7; i++)
          Container(
            decoration: BoxDecoration(
              color: CONTAINER_COLOR_DARK,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 5,
            width: 2,
          ),
      ],
    );
  }
}
