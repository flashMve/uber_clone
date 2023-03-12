import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_rider_app/Global/constants.dart';
import 'package:uber_rider_app/Screens/Home%20Screens/new_ride_screen.dart';
import 'package:uber_rider_app/Screens/Home%20Screens/ride_selection_panel.dart';
import 'package:uber_rider_app/Screens/Home%20Screens/uber_drawer.dart';
import 'package:uber_rider_app/Screens/page.dart';

import '../../Global/config.dart';
import '../../Models/directions.dart';
import 'collapsed_panel.dart';
import 'google_maps_screen.dart';

enum LocationType { pickup, dropoff, none }

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();

  final ValueNotifier<bool> _valueNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _addressAdded = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _panelChecker = ValueNotifier<bool>(false);

  bool isRequesting = false;

  TextEditingController pickUpController = TextEditingController();
  FocusNode pickFocusNode = FocusNode();
  FocusNode dropFocusNode = FocusNode();
  TextEditingController dropOffController = TextEditingController();

  listen() {
    _key.currentState!.animationController!.addListener(() {
      if (_key.currentState!.animationController!.value < 0.3) {
        _valueNotifier.value = false;
      } else {
        _valueNotifier.value = true;
      }
    });
  }

  listenToPanelCheck() {
    _panelChecker.addListener(() {
      getAddressProvider(context).checkIfAddressIsSet();

      if (getAddressProvider(context).getIsAddressSetNotifier.value) {
        _addressAdded.value =
            getAddressProvider(context).getIsAddressSetNotifier.value;
      }

      if (getAddressProvider(context).getPickupAddressNotifier.value != null) {
        pickUpController.text = getAddressProvider(context)
            .getPickupAddressNotifier
            .value!
            .address!;
        if (_panelChecker.value) {
          dropFocusNode.requestFocus();
        }
      }

      if (!_panelChecker.value) {
        dropFocusNode.unfocus();
      }
      if (getAddressProvider(context).getDropoffAddressNotifier.value != null) {
        dropOffController.text = getAddressProvider(context)
            .getDropoffAddressNotifier
            .value!
            .address!;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _key.currentState?.animationController?.removeListener(() {});
    _panelChecker.removeListener(() {});
    _addressAdded.removeListener(() {});
    _valueNotifier.removeListener(() {});
    pickUpController.dispose();
    dropOffController.dispose();
    pickFocusNode.dispose();
    dropFocusNode.dispose();
  }

  void reset(BuildContext context) {
    showLoadingDialog(context);
    _addressAdded.value = false;
    pickUpController.text = "";
    dropOffController.text = "";
    getAddressProvider(context).clearAddresses();
    getAddressProvider(context).getLocation();
    getRiderRequest(context).length.removeListener(() {});
    resetTimer();

    setState(() {
      isRequesting = false;
    });
    pop(context);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      listen();
      listenToPanelCheck();
      listenToUserActiveRides();
      getRiderRequest(context).activeRide.once().then((ride) {
        if (ride.snapshot.exists) {
          setState(() {
            isRequesting = true;
          });
        }
      });
    });
  }

  listenToUserActiveRides() {
    userActiveRide.onValue.listen((event) {
      if (event.snapshot.exists) {
        if (event.snapshot.value != 'waiting') {
          final rideId = event.snapshot.value as String;
          reset(context);
          pushNewScreen(
            context,
            UserRideScreen(rideId: rideId),
          );
        }
      } else {
        setState(() {
          isRequesting = false;
        });
        getRiderRequest(context).initGeoFire();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaScreen(
      child: Scaffold(
        backgroundColor: getBackgroundColor(context),
        body: SliderDrawer(
          key: _key,
          slider: UberDrawer(
            drawerKey: _key,
          ),
          sliderOpenSize: 260,
          isDraggable: true,
          appBar: Container(),
          child: ValueListenableBuilder<bool>(
            valueListenable: _addressAdded,
            builder: (context, added, __) {
              return Stack(
                children: [
                  //GOOGLE MAP
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: added
                        ? getSize(context).height * 0.5 - 10
                        : getSize(context).height * 0.72,
                    child: GoogleMapScreen(
                      controller: _controller,
                    ),
                  ),
                  // Marker Info Window
                  CustomInfoWindow(
                    controller: getAddressProvider(context)
                        .getCustomInfoWindowController,
                    height: 30,
                    width: 250,
                    offset: 55,
                  ),
                  // Time and Distance Widget
                  Positioned(
                    top: 10,
                    left: 60,
                    right: 0,
                    child: ValueListenableBuilder<Directions?>(
                        valueListenable:
                            getAddressProvider(context).getDirectionsNotifier,
                        builder: (ctx, info, __) {
                          return info != null
                              ? Container(
                                  padding: const EdgeInsets.all(13),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: CONTAINER_COLOR_DARK,
                                    borderRadius: BorderRadius.circular(
                                      BUTTON_BORDER_RADIUS,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: CONTAINER_COLOR_DARK
                                            .withOpacity(0.1),
                                        blurRadius: 1,
                                        spreadRadius: 0.5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '${info.distance} , ${info.duration}',
                                    style: TextStyle(
                                      color: TXT_COLOR_LIGHT,
                                      fontFamily: FONT_BOLT_BOLD,
                                      fontSize: FONT_SIZE_14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Container();
                        }),
                  ),
                  // Drawer Button
                  ValueListenableBuilder<bool>(
                    valueListenable: _valueNotifier,
                    builder: (context, value, ch) {
                      return Tooltip(
                        message: added
                            ? "Cancel "
                            : value
                                ? "Close Drawer"
                                : "Open Drawer",
                        decoration: BoxDecoration(
                          color: CONTAINER_COLOR_DARK,
                          borderRadius:
                              BorderRadius.circular(TOOLTIP_BORDER_RADIUS),
                        ),
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          // padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(left: 16, top: 10),
                          decoration: BoxDecoration(
                            color: CONTAINER_COLOR_LIGHT,
                            borderRadius:
                                BorderRadius.circular(BUTTON_BORDER_RADIUS),
                            boxShadow: [
                              BoxShadow(
                                color: CONTAINER_COLOR_DARK.withOpacity(0.1),
                                blurRadius: 1,
                                spreadRadius: 0.5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            alignment: Alignment.center,
                            onPressed: () {
                              if (added) {
                                reset(context);
                              } else {
                                if (value) {
                                  _valueNotifier.value = false;
                                  _key.currentState!.closeSlider();
                                } else {
                                  _valueNotifier.value = true;
                                  _key.currentState!.openSlider();
                                }
                              }
                            },
                            icon: value || added
                                ? const Icon(
                                    FontAwesomeIcons.xmark,
                                    size: 16,
                                    color: ICON_COLOR_DARK,
                                  )
                                : const Icon(
                                    FontAwesomeIcons.barsStaggered,
                                    size: 16,
                                    color: ICON_COLOR_DARK,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),

                  added
                      ? RideSelectionPanel(
                          resetApp: reset,
                          isRequesting: isRequesting,
                        )
                      : Positioned(
                          bottom: 0,
                          child: CollapasedPanelWidget(
                            dropOffController: dropOffController,
                            pickUpController: pickUpController,
                            pickFocusNode: pickFocusNode,
                            dropFocusNode: dropFocusNode,
                            panelChecker: _panelChecker,
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
