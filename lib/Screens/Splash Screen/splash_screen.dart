// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_rider_app/Global/constants.dart';
import 'package:uber_rider_app/Screens/Auth%20Screens/login_screen.dart';
import 'package:uber_rider_app/Screens/page.dart';

import 'fade_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _scale2Controller;
  late AnimationController _widthController;
  late AnimationController _positionController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _scale2Animation;
  late Animation<double> _widthAnimation;
  late Animation<double> _positionAnimation;

  bool hideIcon = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _widthController.forward();
            }
          });

    _widthController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    _widthAnimation =
        Tween<double>(begin: 80.0, end: 300.0).animate(_widthController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _positionController.forward();
            }
          });

    _positionController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _positionAnimation =
        Tween<double>(begin: 0.0, end: 215.0).animate(_positionController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                hideIcon = true;
              });
              _scale2Controller.forward();
            }
          });

    _scale2Controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _scale2Animation =
        Tween<double>(begin: 1.0, end: 32.0).animate(_scale2Controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              popAndPushNewScreen(context, const LoginScreen());
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaScreen(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(3, 9, 23, 1),
        body: Center(
          child: SizedBox(
            width: getSize(context).width,
            height: getSize(context).height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FadeAnimation(
                  delay: 1,
                  child: Container(
                    width: getSize(context).width,
                    height: 20.h,
                    decoration: const BoxDecoration(
                      // color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage(LOGO_WHITE),
                        alignment: Alignment.topCenter,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeAnimation(
                        delay: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Welcome",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: TXT_COLOR_LIGHT, fontSize: FONT_SIZE_30),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FadeAnimation(
                          delay: 1.3,
                          child: Text(
                            "Order a ride from Uber to any location with just a few clicks",
                            style: TextStyle(
                                color: TXT_COLOR_LIGHT.withOpacity(.7),
                                height: 1.4,
                                fontSize: FONT_SIZE_18),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                        height: 25.h,
                      ),
                      FadeAnimation(
                          delay: 1.6,
                          child: AnimatedBuilder(
                            animation: _scaleController,
                            builder: (context, child) => Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Center(
                                  child: AnimatedBuilder(
                                    animation: _widthController,
                                    builder: (context, child) => Container(
                                      width: _widthAnimation.value,
                                      height: 80,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: LETS_GO_CONTAINER_COLOR_LIGHT
                                              .withOpacity(.4)),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setBool(
                                              'isGettingStarted', true);
                                          _scaleController.forward();
                                        },
                                        child: Stack(children: <Widget>[
                                          AnimatedBuilder(
                                            animation: _positionController,
                                            builder: (context, child) =>
                                                Positioned(
                                              left: _positionAnimation.value,
                                              child: AnimatedBuilder(
                                                animation: _scale2Controller,
                                                builder: (context, child) =>
                                                    Transform.scale(
                                                  scale: _scale2Animation.value,
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          LETS_GO_CONTAINER_COLOR_LIGHT,
                                                    ),
                                                    child: hideIcon == false
                                                        ? const Icon(
                                                            FontAwesomeIcons
                                                                .carSide,
                                                            color:
                                                                ICON_COLOR_DARK,
                                                            size: 18,
                                                          )
                                                        : Container(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                )),
                          )),
                      FadeAnimation(
                        delay: 1.6,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 8.0),
                          child: const Text(
                            "Lets Ride",
                            style: TextStyle(
                              color: TXT_COLOR_LIGHT,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
