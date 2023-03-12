import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_rider_app/Models/user_model.dart';
import 'package:uber_rider_app/Screens/Auth%20Screens/login_screen.dart';
import 'package:uber_rider_app/Screens/Drawer%20Screens/about_us.dart';
import 'package:uber_rider_app/Screens/Drawer%20Screens/profile_screen.dart';
import 'package:uber_rider_app/Screens/Drawer%20Screens/trips.dart';
import 'package:uber_rider_app/Widgets/drawer_tile.dart';
import 'package:uber_rider_app/Widgets/is_user_allowed.dart';

import '../../Global/constants.dart';
import '../../Widgets/divider.dart';

class UberDrawer extends StatelessWidget {
  const UberDrawer({
    Key? key,
    required GlobalKey<SliderDrawerState> drawerKey,
  })  : _key = drawerKey,
        super(key: key);

  final GlobalKey<SliderDrawerState> _key;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SPLASH_SCREEN_COLOR,
      child: Column(
        children: [
          Container(
            height: 22.h,
            width: double.maxFinite,
            color: SPLASH_SCREEN_COLOR,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  FontAwesomeIcons.solidCircleUser,
                  color: ICON_COLOR_LIGHT,
                  size: 40,
                ),
                const SizedBox(
                  height: 16,
                ),
                ValueListenableBuilder<UserModel?>(
                    valueListenable: getAuthProvider(context).userGetter,
                    builder: (context, user, ch) {
                      return Text(
                        user?.displayName ?? "Username",
                        style: TextStyle(
                          fontSize: FONT_SIZE_22,
                          fontFamily: FONT_BOLT_BOLD,
                          color: TXT_COLOR_LIGHT,
                        ),
                      );
                    }),
                const SizedBox(
                  height: 8,
                ),
                ValueListenableBuilder<UserModel?>(
                    valueListenable: getAuthProvider(context).userGetter,
                    builder: (context, user, ch) {
                      return Text(
                        user?.email ?? "Email",
                        style: TextStyle(
                          fontSize: FONT_SIZE_16,
                          fontFamily: FONT_BOLT_REGULAR,
                          color: TXT_COLOR_LIGHT,
                        ),
                      );
                    }),
              ],
            ),
          ),
          const CustomDivider(),
          GridView(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            padding: const EdgeInsets.only(right: 8, top: 8),
            physics: const ClampingScrollPhysics(),
            children: [
              UberTile(
                icon: FontAwesomeIcons.userLarge,
                title: "Profile",
                onTap: () {
                  _key.currentState!.closeSlider();
                  pushNewScreen(context, const ProfilePage());
                },
              ),
              UberTile(
                icon: FontAwesomeIcons.suitcaseRolling,
                title: "Trips",
                onTap: () {
                  _key.currentState!.closeSlider();
                  pushNewScreen(context, const AllTrips());
                },
              ),
              UberTile(
                icon: FontAwesomeIcons.circleInfo,
                title: "About Us",
                onTap: () {
                  _key.currentState!.closeSlider();
                  pushNewScreen(context, const AboutUs());
                },
              ),
              CheckUser(
                notAllowedWidget: UberTile(
                  title: "Login",
                  // isEmergency: true,
                  icon: FontAwesomeIcons.rightFromBracket,
                  onTap: () async {
                    pushNewScreen(context, const LoginScreen());
                  },
                ),
                child: UberTile(
                  title: "Logout",
                  isEmergency: true,
                  icon: FontAwesomeIcons.rightFromBracket,
                  onTap: () async {
                    showLoadingDialog(context);
                    await getAuthProvider(context).logout().then((value) {
                      pop(context);
                    });
                  },
                ),
              ),
            ],
          ),
          CheckUser(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
