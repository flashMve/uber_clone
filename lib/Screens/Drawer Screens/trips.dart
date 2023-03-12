import 'dart:developer';

import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:uber_rider_app/Models/ride_request_model.dart';
import 'package:uber_rider_app/Screens/Splash%20Screen/fade_animation.dart';
import 'package:uber_rider_app/Screens/page.dart';
import 'package:uber_rider_app/Services/Request%20Provider/ride_request.dart';

import '../../Global/constants.dart';

class AllTrips extends StatelessWidget {
  const AllTrips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeAreaScreen(
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: SPLASH_SCREEN_COLOR,
            title: Text(
              "All Trips",
              style: TextStyle(
                fontFamily: FONT_BOLT_BOLD,
                fontSize: FONT_SIZE_16,
                color: TXT_COLOR_LIGHT,
              ),
            ),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: SPLASH_COLOR_LIGHT,
              isScrollable: true,
              labelColor: TXT_COLOR_LIGHT,
              tabs: [
                Tab(
                  child: Text(
                    "Completed Trips",
                    style: TextStyle(
                      fontSize: FONT_SIZE_14,
                      fontFamily: FONT_BOLT_BOLD,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "In Progress",
                    style: TextStyle(
                      fontSize: FONT_SIZE_14,
                      fontFamily: FONT_BOLT_BOLD,
                    ),
                  ),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TripsScreen(
                getData: () => getAuthProvider(context).getCompletedTrips(),
              ),
              TripsScreen(
                getData: () => getAuthProvider(context).getOngoingTrips(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TripsScreen extends StatefulWidget {
  const TripsScreen({Key? key, required this.getData}) : super(key: key);
  // final Future<List<RideRequestModel?>>Funtion() getData;
  final Future<List<RideRequestModel?>> Function() getData;

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  bool isLoading = false;
  List<RideRequestModel?> data = [];

  Future<void> getData() async {
    if (mounted) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      data = await widget.getData();
      log(data.toString());
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: LoadingBouncingGrid.square(
              backgroundColor: SPLASH_SCREEN_COLOR,
              size: 25,
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: data.length,
            itemBuilder: (context, index) => TripDetailCard(
              rideRequestModel: data[index]!,
            ),
          );
  }
}

class TripDetailCard extends StatelessWidget {
  const TripDetailCard({
    Key? key,
    required this.rideRequestModel,
  }) : super(key: key);

  final RideRequestModel rideRequestModel;

  getStatus(RideStatus type) {
    switch (type) {
      case RideStatus.accepted:
        return "Accepted on";
      case RideStatus.cancelled:
        return "Cancelled on";
      case RideStatus.finished:
        return "Completed on";
      default:
        return "In Progress";
    }
  }

  getDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
      child: Material(
        elevation: 10,
        color: Colors.transparent,
        child: CouponCard(
          height: 150,
          clockwise: true,
          curveRadius: 10,
          backgroundColor: Colors.transparent,
          curveAxis: Axis.vertical,
          firstChild: Container(
            alignment: Alignment.center,
            color: CONTAINER_COLOR_DARK,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${rideRequestModel.price} \$ \nPaid",
                  style: TextStyle(
                    fontFamily: FONT_BOLT_BOLD,
                    fontSize: kIsWeb ? FONT_SIZE_18 : FONT_SIZE_22,
                    color: TXT_COLOR_LIGHT,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${getStatus(rideRequestModel.status!)} ${getDate(rideRequestModel.startTime!)}",
                  style: TextStyle(
                    fontFamily: FONT_BOLT_BOLD,
                    fontSize: FONT_SIZE_14,
                    color: TXT_COLOR_LIGHT,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          secondChild: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
            color: Colors.white,
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(
                      "${rideRequestModel.currentLocation!.address}",
                      style: TextStyle(
                        fontFamily: FONT_BOLT_BOLD,
                        fontSize: FONT_SIZE_14,
                        color: TXT_COLOR_DARK,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  _buildDots(),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, top: 4),
                    child: Text(
                      "${rideRequestModel.destinationLocation!.address}",
                      style: TextStyle(
                        fontFamily: FONT_BOLT_BOLD,
                        fontSize: FONT_SIZE_14,
                        overflow: TextOverflow.ellipsis,
                        color: TXT_COLOR_DARK,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildDots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Create a dot container for each dot
        for (int i = 0; i < 6; i++)
          FadeAnimationChild(
            prop: AniProps.opacity,
            child: Container(
              margin: EdgeInsets.only(
                top: 5,
                left: (i == 0 || i == 5) ? 6 : 8,
                right: (i == 0 || i == 5) ? 6 : 8,
              ),
              alignment: Alignment.centerLeft,
              child: Icon(
                FontAwesomeIcons.circleDot,
                size: (i == 0 || i == 5) ? 8 : 4,
                color: getColorOfRideStatus(rideRequestModel.status!),
              ),
            ),
          ),
      ],
    );
  }
}
