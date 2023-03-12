// ignore: constant_identifier_names

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_rider_app/Global/config.dart';
import 'package:uber_rider_app/main.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:uber_rider_app/Services/Data%20Provider/address_provider.dart';
import 'package:uber_rider_app/Services/Request%20Provider/ride_request.dart';

import '../Services/Auth Provider/user_auth_provider.dart';
import '../Services/Data Provider/cloud_functions.dart';
import '../Widgets/floating_widget.dart';

// ignore: constant_identifier_names
const RIDER_LOGIN_TEXT = "Ride with Uber";
// ignore: constant_identifier_names
// const SPLASH_SCREEN_COLOR = Color.fromRGBO(3, 9, 23, 1);

// ignore: constant_identifier_names
const SPLASH_SCREEN_COLOR = Color.fromRGBO(3, 9, 23, 1);
// ignore: constant_identifier_names
const SPLASH_COLOR_LIGHT = Colors.white;
// ignore: constant_identifier_names
const SPLASH_COLOR_DARK = Colors.black;

// ignore: constant_identifier_names
const LOADIN_COLOR = Colors.black;

//Customized google map style json converted to string.
// ignore: non_constant_identifier_names, constant_identifier_names
const MAP_STYLE =
    "[{\"featureType\":\"all\",\"elementType\":\"geometry.fill\",\"stylers\":[{\"weight\":\"2.00\"}]},{\"featureType\":\"all\",\"elementType\":\"geometry.stroke\",\"stylers\":[{\"color\":\"#9c9c9c\"}]},{\"featureType\":\"all\",\"elementType\":\"labels.text\",\"stylers\":[{\"visibility\":\"on\"}]},{\"featureType\":\"landscape\",\"elementType\":\"all\",\"stylers\":[{\"color\":\"#f2f2f2\"}]},{\"featureType\":\"landscape\",\"elementType\":\"geometry.fill\",\"stylers\":[{\"color\":\"#ffffff\"}]},{\"featureType\":\"landscape.man_made\",\"elementType\":\"geometry.fill\",\"stylers\":[{\"color\":\"#ffffff\"}]},{\"featureType\":\"poi\",\"elementType\":\"all\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"road\",\"elementType\":\"all\",\"stylers\":[{\"saturation\":-100},{\"lightness\":45}]},{\"featureType\":\"road\",\"elementType\":\"geometry.fill\",\"stylers\":[{\"color\":\"#eeeeee\"}]},{\"featureType\":\"road\",\"elementType\":\"labels.text.fill\",\"stylers\":[{\"color\":\"#7b7b7b\"}]},{\"featureType\":\"road\",\"elementType\":\"labels.text.stroke\",\"stylers\":[{\"color\":\"#ffffff\"}]},{\"featureType\":\"road.highway\",\"elementType\":\"all\",\"stylers\":[{\"visibility\":\"simplified\"}]},{\"featureType\":\"road.arterial\",\"elementType\":\"labels.icon\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"transit\",\"elementType\":\"all\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"water\",\"elementType\":\"all\",\"stylers\":[{\"color\":\"#46bcec\"},{\"visibility\":\"on\"}]},{\"featureType\":\"water\",\"elementType\":\"geometry.fill\",\"stylers\":[{\"color\":\"#c8d7d4\"}]},{\"featureType\":\"water\",\"elementType\":\"labels.text.fill\",\"stylers\":[{\"color\":\"#070707\"}]},{\"featureType\":\"water\",\"elementType\":\"labels.text.stroke\",\"stylers\":[{\"color\":\"#ffffff\"}]}]";

// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_58 = 58.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_56 = 56.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_54 = 54.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_52 = 52.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_50 = 50.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_48 = 48.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_46 = 46.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_44 = 44.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_42 = 42.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_38 = 38.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_40 = 40.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_36 = 36.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_34 = 34.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_32 = 32.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_30 = 30.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_28 = 28.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_26 = 26.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_24 = 24.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_22 = kIsWeb ? 18.sp : 22.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_20 = kIsWeb ? 16.sp : 20.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_18 = kIsWeb ? 14.sp : 18.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_16 = kIsWeb ? 12.sp : 16.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_14 = kIsWeb ? 12.sp : 14.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_12 = 12.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_8 = 8.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_10 = 10.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_6 = 6.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_4 = 4.0.sp;
// ignore: constant_identifier_names, non_constant_identifier_names
final FONT_SIZE_2 = 2.0.sp;
// ignore: constant_identifier_names

// ignore: constant_identifier_names
const TXT_COLOR_LIGHT = Colors.white;
// ignore: constant_identifier_names
const TXT_COLOR_GREY = Colors.grey;
// ignore: constant_identifier_names
const TXT_COLOR_DARK = Colors.black;
// ignore: constant_identifier_names
const TXT_COLOR_ERROR = Colors.red;
// ignore: constant_identifier_names
const TXT_COLOR_WARNING = Colors.yellowAccent;

// ignore: constant_identifier_names
const LETS_GO_CONTAINER_COLOR_LIGHT = Colors.white;
// ignore: constant_identifier_names
const CONTAINER_COLOR_LIGHT = Colors.white;
// ignore: constant_identifier_names
const CONTAINER_COLOR_DARK = Colors.black;
// ignore: constant_identifier_names
const CONTAINER_COLOR_GREY = Colors.grey;
// ignore: constant_identifier_names
const CONTAINER_COLOR_ONLINE = Colors.green;
// ignore: constant_identifier_names
const CONTAINER_COLOR_OFFLINE = Colors.red;

// ignore: constant_identifier_names
const FOCUS_COLOR_LIGHT = Colors.grey;
// ignore: constant_identifier_names
const FOCUS_COLOR_DARK = Colors.black;

// ignore: constant_identifier_names
const ICON_COLOR_LIGHT = Colors.white;
// ignore: constant_identifier_names
const ICON_COLOR_DARK = Colors.black;
// ignore: constant_identifier_names
const ICON_COLOR_ERROR = Colors.red;

// ignore: constant_identifier_names
const FILL_COLOR_LIGHT = Colors.white;
// ignore: constant_identifier_names
const FILL_COLOR_DARK = Colors.black;

// ignore: constant_identifier_names
const BTN_COLOR_LIGHT = Colors.grey;
// ignore: constant_identifier_names
const BTN_COLOR_DARK = Colors.black;

// ignore: constant_identifier_names
const CURSOR_COLOR_LIGHT = Colors.white;
// ignore: constant_identifier_names
const CURSOR_COLOR_DARK = Colors.black;

// ignore: constant_identifier_names
const BORDER_COLOR_LIGHT = Colors.white;
// ignore: constant_identifier_names
const BORDER_COLOR_DARK = Colors.black;

// ignore: constant_identifier_names
const RIDER_SIGNUP_TEXT = "Sign Up as Rider";
// ignore: constant_identifier_names
const RIDER_SIGNUP_TEXT_CAR_DETAILS = "Fill the details of your car";
// ignore: constant_identifier_names
const RIDER_SIGNUP_TEXT_PASSWORD = "Create a Password for your Account.";
// ignore: constant_identifier_names
const FONT_BOLT_BOLD = "Bolt SemiBold";
// ignore: constant_identifier_names
const FONT_BOLT_REGULAR = "Bolt Regular";
// ignore: constant_identifier_names
const FONT_SIGNATRA = "Signatra";
// ignore: constant_identifier_names
const LOGO = "assets/images/Uber_Logo_Black.png";
// ignore: constant_identifier_names
const LOGO_WHITE = "assets/images/Uber_Logo_White.png";
// ignore: constant_identifier_names
const MAP_ICON_BLUE = "assets/images/map_icon_blue.png";
// ignore: constant_identifier_names
const MAP_ICON_BLACK = "assets/images/map_icon_black.png";
// ignore: constant_identifier_names
const MAP_CAR = "assets/images/car.png";
// ignore: constant_identifier_names
const OTP_ILLUSTRATION = "assets/images/otp.png";
// ignore: constant_identifier_names
const double BUTTON_BORDER_RADIUS = 2;
// ignore: constant_identifier_names
const double TILE_BORDER_RADIUS = 2;
// ignore: constant_identifier_names
const double TOOLTIP_BORDER_RADIUS = 2;
// ignore: constant_identifier_names
const double TEXTFIELD_BORDER_RADIUS = 2;

// ? Getting the size of the screen
Size getSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

// ? Push a new screen
void pushNewScreen(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.fade,
      child: screen,
      duration: const Duration(milliseconds: 500),
    ),
  );
}

// ? Pop the current screen
void popScreen(BuildContext context) {
  Navigator.pop(context);
}

// ? Pop the current screen and push a new screen
void popAndPushNewScreen(BuildContext context, Widget screen) {
  Navigator.pushReplacement(
    context,
    PageTransition(
      type: PageTransitionType.fade,
      child: screen,
      duration: const Duration(milliseconds: 500),
    ),
  );
}

// ? get Background color from theme
Color getBackgroundColor(BuildContext context) {
  return Theme.of(context).backgroundColor;
}

// ? get AuthProvider from Provider
AuthProvider getAuthProvider(BuildContext context) {
  return Provider.of<AuthProvider>(navigatorKey.currentContext!, listen: false);
}

showLoadingDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          width: 100.0,
          height: 70.0,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: LoadingBouncingGrid.square(
            backgroundColor: Colors.black,
          ),
        ),
      );
    },
  );
}

// ? Close the Current Screen
void pop(BuildContext context) {
  Navigator.of(context).pop();
}

AddressProvider getAddressProvider(BuildContext context) {
  return Provider.of<AddressProvider>(navigatorKey.currentContext!,
      listen: false);
}

showSnackBar(
    {required String message,
    Color? color,
    int time = 8,
    Color backgroundColor = SPLASH_SCREEN_COLOR}) {
  ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: color ?? TXT_COLOR_LIGHT,
          fontFamily: FONT_BOLT_BOLD,
          fontSize: FONT_SIZE_16,
        ),
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor.withOpacity(0.8),
      duration: Duration(seconds: time),
      padding: const EdgeInsets.all(16),
      dismissDirection: DismissDirection.vertical,
    ),
  );
}

RiderRequest getRiderRequest(BuildContext context) {
  return Provider.of<RiderRequest>(navigatorKey.currentContext!, listen: false);
}

resetTimer() {
  driverTimeOut = 40;
  timer?.cancel();
}

Future<T> showFloatingModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
}) async {
  final result = await showCustomModalBottomSheet(
      context: context,
      builder: builder,
      containerWidget: (_, animation, child) => FloatingModal(
            child: child,
          ),
      expand: false);

  return result;
}

showRatingDialog({required String rideId, required String driverId}) {
  final dialog = RatingDialog(
    starSize: 20,
    submitButtonTextStyle: TextStyle(
      color: CONTAINER_COLOR_DARK,
      fontSize: FONT_SIZE_14,
      fontFamily: FONT_BOLT_BOLD,
    ),
    initialRating: 0.0,
    title: Text(
      'Rate your experience',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: FONT_SIZE_18,
        fontFamily: FONT_BOLT_BOLD,
      ),
    ),
    // encourage your user to leave a high rating?
    message: Text(
      'Swipe or Tap a star to set your rating.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: FONT_SIZE_16 - 1,
        fontFamily: FONT_BOLT_REGULAR,
      ),
    ),
    starColor: TXT_COLOR_ERROR,
    image: Image.asset(
      LOGO,
      height: 100,
      width: 100,
    ),
    submitButtonText: 'Submit',
    onCancelled: () => log('cancelled'),
    enableComment: false,
    showCloseButton: true,

    onSubmitted: (response) {
      showLoadingDialog(navigatorKey.currentContext!);
      CloudFunctions()
          .updateDriverRating(
        rating: response.rating,
        driverId: driverId,
        rideId: rideId,
      )
          .then((result) {
        final message = result['message'];
        showSnackBar(
          message: message,
          time: 4,
        );
        pop(navigatorKey.currentContext!);
      });
    },
  );

  showDialog(
    context: navigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (context) => dialog,
  );
}
