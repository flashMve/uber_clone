// // ignore: constant_identifier_names

// import 'package:flutter/material.dart';
// import 'package:loading_animations/loading_animations.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';
// import 'package:uber_rider_app/Services/Data%20Provider/address_provider.dart';
// import 'package:uber_rider_app/Services/Request%20Provider/ride_request.dart';

// import '../Services/Auth Provider/user_auth_provider.dart';
// import '../Widgets/floating_widget.dart';

// // ignore: constant_identifier_names
// const RIDER_LOGIN_TEXT = "Login with Uber";
// // ignore: constant_identifier_names
// // const SPLASH_SCREEN_COLOR = Color.fromRGBO(3, 9, 23, 1);

// // ignore: constant_identifier_names
// const SPLASH_SCREEN_COLOR = Color.fromRGBO(3, 9, 23, 1);
// // ignore: constant_identifier_names
// const SPLASH_COLOR_LIGHT = Colors.white;
// // ignore: constant_identifier_names
// const SPLASH_COLOR_DARK = Colors.black;

// // ignore: constant_identifier_names
// const LOADIN_COLOR = Colors.black;

// // ignore: constant_identifier_names
// const TXT_COLOR_LIGHT = Colors.white;
// // ignore: constant_identifier_names
// const TXT_COLOR_GREY = Colors.grey;
// // ignore: constant_identifier_names
// const TXT_COLOR_DARK = Colors.black;
// // ignore: constant_identifier_names
// const TXT_COLOR_ERROR = Colors.red;
// // ignore: constant_identifier_names
// const TXT_COLOR_WARNING = Colors.yellowAccent;

// // ignore: constant_identifier_names
// const LETS_GO_CONTAINER_COLOR_LIGHT = Colors.white;
// // ignore: constant_identifier_names
// const CONTAINER_COLOR_LIGHT = Colors.white;
// // ignore: constant_identifier_names
// const CONTAINER_COLOR_DARK = Colors.black;
// // ignore: constant_identifier_names
// const CONTAINER_COLOR_GREY = Colors.grey;

// // ignore: constant_identifier_names
// const FOCUS_COLOR_LIGHT = Colors.grey;
// // ignore: constant_identifier_names
// const FOCUS_COLOR_DARK = Colors.black;

// // ignore: constant_identifier_names
// const ICON_COLOR_LIGHT = Colors.white;
// // ignore: constant_identifier_names
// const ICON_COLOR_DARK = Colors.black;
// // ignore: constant_identifier_names
// const ICON_COLOR_ERROR = Colors.red;

// // ignore: constant_identifier_names
// const FILL_COLOR_LIGHT = Colors.white;
// // ignore: constant_identifier_names
// const FILL_COLOR_DARK = Colors.black;

// // ignore: constant_identifier_names
// const BTN_COLOR_LIGHT = Colors.grey;
// // ignore: constant_identifier_names
// const BTN_COLOR_DARK = Colors.black;

// // ignore: constant_identifier_names
// const CURSOR_COLOR_LIGHT = Colors.white;
// // ignore: constant_identifier_names
// const CURSOR_COLOR_DARK = Colors.black;

// // ignore: constant_identifier_names
// const BORDER_COLOR_LIGHT = Colors.white;
// // ignore: constant_identifier_names
// const BORDER_COLOR_DARK = Colors.black;

// // ignore: constant_identifier_names
// const RIDER_SIGNUP_TEXT = "Sign Up with Uber";
// // ignore: constant_identifier_names
// const FONT_BOLT_BOLD = "Bolt SemiBold";
// // ignore: constant_identifier_names
// const FONT_BOLT_REGULAR = "Bolt Regular";
// // ignore: constant_identifier_names
// const FONT_SIGNATRA = "Signatra";
// // ignore: constant_identifier_names
// const LOGO = "assets/images/Uber_Logo_Black.png";
// // ignore: constant_identifier_names
// const LOGO_WHITE = "assets/images/Uber_Logo_White.png";
// // ignore: constant_identifier_names
// const OTP_ILLUSTRATION = "assets/images/otp.png";
// // ignore: constant_identifier_names
// const double BUTTON_BORDER_RADIUS = 2;
// // ignore: constant_identifier_names
// const double TILE_BORDER_RADIUS = 2;
// // ignore: constant_identifier_names
// const double TOOLTIP_BORDER_RADIUS = 2;
// // ignore: constant_identifier_names
// const double TEXTFIELD_BORDER_RADIUS = 2;

// // ? Getting the size of the screen
// Size getSize(BuildContext context) {
//   return MediaQuery.of(context).size;
// }

// // ? Push a new screen
// void pushNewScreen(BuildContext context, Widget screen) {
//   Navigator.push(
//     context,
//     PageTransition(
//       type: PageTransitionType.fade,
//       child: screen,
//       duration: const Duration(milliseconds: 500),
//     ),
//   );
// }

// // ? Pop the current screen
// void popScreen(BuildContext context) {
//   Navigator.pop(context);
// }

// // ? Pop the current screen and push a new screen
// void popAndPushNewScreen(BuildContext context, Widget screen) {
//   Navigator.pushReplacement(
//     context,
//     PageTransition(
//       type: PageTransitionType.fade,
//       child: screen,
//       duration: const Duration(milliseconds: 500),
//     ),
//   );
// }

// // ? get Background color from theme
// Color getBackgroundColor(BuildContext context) {
//   return Theme.of(context).backgroundColor;
// }

// // ? get AuthProvider from Provider
// AuthProvider getAuthProvider(BuildContext context) {
//   return Provider.of<AuthProvider>(context, listen: false);
// }

// showLoadingDialog(BuildContext context) {
//   return showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Center(
//         child: Container(
//           width: 100.0,
//           height: 70.0,
//           alignment: Alignment.center,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.all(
//               Radius.circular(5.0),
//             ),
//           ),
//           child: LoadingBouncingGrid.square(
//             backgroundColor: Colors.black,
//           ),
//         ),
//       );
//     },
//   );
// }

// // ? Close the Current Screen
// void pop(BuildContext context) {
//   Navigator.pop(context);
// }

// AddressProvider getAddressProvider(BuildContext context) {
//   return Provider.of<AddressProvider>(context, listen: false);
// }

// RiderRequest getRiderRequest(BuildContext context) {
//   return Provider.of<RiderRequest>(context, listen: false);
// }

// Future<T> showFloatingModalBottomSheet<T>({
//   required BuildContext context,
//   required WidgetBuilder builder,
//   Color? backgroundColor,
// }) async {
//   final result = await showCustomModalBottomSheet(
//       context: context,
//       builder: builder,
//       containerWidget: (_, animation, child) => FloatingModal(
//             child: child,
//           ),
//       expand: false);

//   return result;
// }
