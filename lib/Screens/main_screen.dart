import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_rider_app/Global/constants.dart';
import 'package:uber_rider_app/Models/user_model.dart';
import 'package:uber_rider_app/Screens/Home%20Screens/home_screen.dart';
import 'package:uber_rider_app/Screens/Splash%20Screen/splash_screen.dart';

import 'Auth Screens/login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final isGettingStarted = ValueNotifier(false);
  final isWaiting = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    checkIsGettingStarted();
    getAddressProvider(context).getIcon();
    getAuthProvider(context).getCurrentUser().then((userLoggedIn) {
      isWaiting.value = false;
    });
  }

  checkIsGettingStarted() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isGettingStarted")) {
      isGettingStarted.value = prefs.getBool("isGettingStarted")!;
    } else {
      prefs.setBool('isGettingStarted', false);
      isGettingStarted.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isGettingStarted,
        builder: (ctx, isGetting, c) {
          if (!isGetting) {
            return const SplashScreen();
          } else {
            return Stack(
              children: [
                ValueListenableBuilder<UserModel?>(
                  valueListenable: getAuthProvider(context).userGetter,
                  builder: (context, user, c) {
                    if (user == null) {
                      return const LoginScreen();
                    } else {
                      return const HomeScreen();
                    }
                  },
                ),
                ValueListenableBuilder<bool>(
                    valueListenable: isWaiting,
                    builder: (context, waiting, ch) {
                      return waiting
                          ? Container(
                              height: getSize(context).height,
                              width: getSize(context).width,
                              color: CONTAINER_COLOR_LIGHT.withOpacity(0.2),
                              child: Center(
                                child: LoadingBouncingGrid.square(
                                  backgroundColor: Colors.black,
                                ),
                              ),
                            )
                          : const SizedBox();
                    }),
              ],
            );
          }
        });
  }
}
