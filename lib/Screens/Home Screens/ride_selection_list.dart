import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_rider_app/Screens/Home%20Screens/ride_selection_tile.dart';

import '../../Global/constants.dart';
import '../../Global/uber_cars.dart';
import '../../Models/ride_request_model.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/is_user_allowed.dart';
import '../Splash Screen/fade_animation.dart';

class RideSelectionList extends StatefulWidget {
  const RideSelectionList({
    Key? key,
    this.data,
    required this.scrollController,
    required this.isFull,
    required this.isRequested,
    required this.driversAvailable,
    required this.searchNearbyDrivers,
  }) : super(key: key);
  final Object? data;
  final ScrollController? scrollController;
  final ValueNotifier<bool> isFull;
  final ValueNotifier<bool> isRequested;
  final ValueNotifier<bool> driversAvailable;
  final Function searchNearbyDrivers;

  @override
  State<RideSelectionList> createState() => _RideSelectionListState();
}

class _RideSelectionListState extends State<RideSelectionList> {
  final List<bool> _selected =
      List.generate(uberRides.length, (index) => false);
  int? selectIndex;
  bool loading = false;

  selectTile(int index) {
    for (int i = 0; i < _selected.length; i++) {
      if (i == index && !_selected[i]) {
        _selected[i] = true;
      } else {
        _selected[i] = false;
      }
    }

    if (_selected.elementAt(index)) {
      selectIndex = index;
    } else {
      selectIndex = null;
    }
    if (mounted) {
      setState(() {});
    }
  }

  getCarType(String id) {
    // log(id);
    switch (id) {
      case "x":
        return CarType.uberX;
      case "go":
        return CarType.ubergo;
      case "auto":
        return CarType.auto;
      case "bike":
        return CarType.bike;
      case "mini":
        return CarType.mini;
    }
  }

  calculateFare(BuildContext context, double price, rates) {
    final distanceFare = (getAddressProvider(context)
                .getDirectionsNotifier
                .value!
                .distanceValue! /
            1000) *
        price;
    final durationFare = (getAddressProvider(context)
                .getDirectionsNotifier
                .value!
                .durationValue! /
            60) *
        price;
    return double.parse(
        ((distanceFare + durationFare) * rates).toDouble().toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: widget.driversAvailable,
            builder: (context, areAvailable, __) {
              return areAvailable
                  ? loading
                      ? Expanded(
                          child: ListView(
                            controller: widget.scrollController,
                            children: [
                              Center(
                                child: LoadingBouncingGrid.square(
                                  backgroundColor: LOADIN_COLOR,
                                  size: 25,
                                ),
                              )
                            ],
                          ),
                        )
                      : NotificationListener<DraggableScrollableNotification>(
                          onNotification: (notification) {
                            if (notification.extent >= 0.97) {
                              widget.isFull.value = true;
                            } else {
                              widget.isFull.value = false;
                            }
                            return true;
                          },
                          child: Expanded(
                            child: ListView.builder(
                              controller: widget.scrollController,
                              itemCount: uberRides.length,
                              itemBuilder: (ctx, i) => FadeAnimationChild(
                                delay: i + 1,
                                prop: AniProps.x,
                                child: RideSelectionTile(
                                  index: i,
                                  onTap: (index) {
                                    selectTile(index);
                                  },
                                  selected: _selected[i],
                                  rates: double.parse(
                                      (widget.data as Map)["rates"].toString()),
                                  rideDetails: uberRides[i],
                                  price: double.parse(
                                      (widget.data as Map)[uberRides[i].id]
                                          .toString()),
                                ),
                              ),
                            ),
                          ),
                        )
                  : Expanded(
                      child: ListView(
                        controller: widget.scrollController,
                        padding: const EdgeInsets.all(8),
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/lost.png",
                                height: 20.h,
                                width: 20.h,
                              ),
                              Text(
                                "No Drivers Available",
                                style: TextStyle(
                                  fontSize: FONT_SIZE_18,
                                  fontFamily: FONT_BOLT_BOLD,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '''Sorry no drivers are available at the moment. Please try again later.''',
                                style: TextStyle(
                                  fontSize: FONT_SIZE_16,
                                  fontFamily: FONT_BOLT_REGULAR,
                                ),
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
            },
          ),
          selectIndex != null
              ? CheckUser(
                  allowedWidget: (userVerified) => UberButton(
                    flex: 0,
                    onPressed: userVerified
                        ? () {
                            setState(() {
                              loading = true;
                            });
                            // Calculate fare
                            final price = calculateFare(
                                context,
                                double.parse((widget.data
                                        as Map)[uberRides[selectIndex!].id]
                                    .toString()),
                                double.parse(
                                    (widget.data as Map)["rates"].toString()));

                            //Creating Request
                            getRiderRequest(context)
                                .createRideRequest(
                                    context: context,
                                    carType:
                                        getCarType(uberRides[selectIndex!].id!),
                                    price: price)
                                .then((value) {
                              widget.searchNearbyDrivers(
                                  getCarType(uberRides[selectIndex!].id!));
                              setState(() {
                                loading = true;
                              });
                              widget.isRequested.value = true;
                            });
                          }
                        : () {},
                    text: !userVerified
                        ? "Verify Your Phone Number."
                        : "Request Ride",
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
