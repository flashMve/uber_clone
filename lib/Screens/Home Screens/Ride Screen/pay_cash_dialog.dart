import 'package:flutter/material.dart';
import 'package:uber_rider_app/main.dart';

import '../../../Global/constants.dart';
import '../../../Widgets/custom_button.dart';

class PayCash extends StatelessWidget {
  const PayCash({
    Key? key,
    required this.cash,
    required this.paymentMethod,
    required this.rideId,
    required this.driverId,
  }) : super(key: key);
  final String cash;
  final String rideId;
  final String driverId;
  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "\$ $cash",
                style: const TextStyle(
                  fontSize: 50,
                  fontFamily: FONT_BOLT_REGULAR,
                  color: TXT_COLOR_ERROR,
                ),
              ),
              const Text(
                "Trip-Fare",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: FONT_BOLT_REGULAR,
                  color: TXT_COLOR_GREY,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "This is the amount that will be paid for the trip. Pay Cash to the Driver.",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: FONT_BOLT_REGULAR,
                  color: TXT_COLOR_GREY.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              // const Spacer(),
            ],
          ),
        ),
        NonFlexUberButton(
          onPressed: () async {
            pop(navigatorKey.currentContext!);
            pop(navigatorKey.currentContext!);
            getRiderRequest(navigatorKey.currentContext!).initGeoFire();
          },
          text: "Pay Cash",
          backGroundColor: CONTAINER_COLOR_ONLINE,
        )
      ],
    );
  }
}
