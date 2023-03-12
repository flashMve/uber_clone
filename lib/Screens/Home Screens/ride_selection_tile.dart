import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Global/constants.dart';
import '../../Models/uber_car_model.dart';

class RideSelectionTile extends StatelessWidget {
  const RideSelectionTile(
      {Key? key,
      required this.rideDetails,
      required this.onTap,
      required this.rates,
      required this.index,
      this.selected = false,
      required this.price})
      : super(key: key);

  final UberRide rideDetails;
  final Function(int) onTap;
  final double rates;
  final bool selected;
  final double price;
  final int index;

  calculateFare(BuildContext context) {
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
    return ((distanceFare + durationFare) * rates)
        .toDouble()
        .toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? CONTAINER_COLOR_DARK.withOpacity(0.04)
          : Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        onTap: () => onTap(index),
        leading: SizedBox(
          height: 15.h,
          width: 15.w,
          child: Image.asset(
            rideDetails.image!,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          rideDetails.name!,
          style: TextStyle(
            fontFamily: FONT_BOLT_BOLD,
            fontSize: FONT_SIZE_14,
            color: TXT_COLOR_DARK,
          ),
        ),
        subtitle: Text(
          rideDetails.subtitle!,
          style: TextStyle(
            fontFamily: FONT_BOLT_REGULAR,
            fontSize: FONT_SIZE_12,
            color: TXT_COLOR_GREY,
          ),
        ),
        trailing: Text(
          "${calculateFare(context) ?? 0}  \$",
          style: TextStyle(
            fontFamily: FONT_BOLT_BOLD,
            fontSize: FONT_SIZE_16 - 1,
            color: TXT_COLOR_DARK,
          ),
        ),
      ),
    );
  }
}
