import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_rider_app/Screens/Home%20Screens/panel_body.dart';

import '../../Global/constants.dart';
import '../../Models/user_model.dart';
import '../../Widgets/custom_textfield.dart';

class CollapasedPanelWidget extends StatelessWidget {
  const CollapasedPanelWidget({
    Key? key,
    required this.dropFocusNode,
    required this.dropOffController,
    required this.pickFocusNode,
    required this.pickUpController,
    required this.panelChecker,
  }) : super(key: key);

  final TextEditingController pickUpController;
  final FocusNode pickFocusNode;
  final FocusNode dropFocusNode;
  final TextEditingController dropOffController;
  final ValueNotifier<bool> panelChecker;

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour > 45 && hour < 12) {
      return 'Morning';
    }
    if (hour > 12 && hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(left: 5, right: 5),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      height: 25.h,
      width: getSize(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<UserModel?>(
              valueListenable: getAuthProvider(context).userGetter,
              builder: (context, user, __) {
                return Text(
                  "${greeting()}, ${user?.fname ?? "There"}",
                  style: TextStyle(
                    fontSize: FONT_SIZE_16 - 1,
                    fontFamily: FONT_BOLT_BOLD,
                    color: TXT_COLOR_DARK,
                  ),
                );
              }),
          const SizedBox(height: 4),
          Text(
            "Where to?",
            style: TextStyle(
              fontSize: FONT_SIZE_20,
              fontWeight: FontWeight.bold,
              fontFamily: FONT_BOLT_BOLD,
              color: TXT_COLOR_DARK,
            ),
          ),
          const SizedBox(height: 10),
          CustomTextFieldOnly(
            controller: dropOffController,
            focusNode: FocusNode(),
            submit: (val) {},
            enabled: false,
            hint: "Drop Off Location",
            label: "Drop Off Location",
            sufixIcon: FontAwesomeIcons.locationDot,
            onPressed: () {
              panelChecker.value = true;
              showFloatingModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return PanelOverlay(
                    dropFocusNode: dropFocusNode,
                    dropOffController: dropOffController,
                    pickFocusNode: pickFocusNode,
                    pickUpController: pickUpController,
                    panelChecker: panelChecker,
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
