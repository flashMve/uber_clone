import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_rider_app/Global/constants.dart';
import 'package:uber_rider_app/Screens/Auth%20Screens/login_screen.dart';
import 'package:uber_rider_app/Screens/Auth%20Screens/signup_screen.dart';
import 'package:uber_rider_app/Screens/Home%20Screens/home_screen.dart';
import 'package:uber_rider_app/Screens/main_screen.dart';
import 'package:uber_rider_app/Services/Data%20Provider/address_provider.dart';
import 'package:uber_rider_app/Services/Request%20Provider/ride_request.dart';

import 'Services/Auth Provider/user_auth_provider.dart';
import 'Services/Data Provider/cloud_functions.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  CloudFunctions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddressProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RiderRequest(),
        ),
      ],
      child: FirebasePhoneAuthProvider(
        child: ResponsiveSizer(builder: (context, orientation, screenType) {
          return MaterialApp(
            title: 'Uber Rider',
            navigatorKey: navigatorKey,
            theme: ThemeData(
              fontFamily: FONT_BOLT_REGULAR,
              backgroundColor: Colors.white,
              primarySwatch: MaterialColor(100, {
                50: SPLASH_COLOR_DARK.withOpacity(0.05),
                100: SPLASH_COLOR_DARK,
                200: SPLASH_COLOR_DARK.withOpacity(0.2),
                300: SPLASH_COLOR_DARK.withOpacity(0.3),
                400: SPLASH_COLOR_DARK.withOpacity(0.4),
                500: SPLASH_COLOR_DARK.withOpacity(0.5),
                600: SPLASH_COLOR_DARK.withOpacity(0.6),
                700: SPLASH_COLOR_DARK.withOpacity(0.7),
                800: SPLASH_COLOR_DARK.withOpacity(0.8),
                900: SPLASH_COLOR_DARK.withOpacity(0.9),
              }),
            ),
            debugShowCheckedModeBanner: false,
            home: const MainScreen(),
            routes: {
              LoginScreen.routeName: (context) => const LoginScreen(),
              SignUpScreen.routeName: (context) => const SignUpScreen(),
              HomeScreen.routeName: (context) => const HomeScreen(),
            },
          );
        }),
      ),
    );
  }
}
