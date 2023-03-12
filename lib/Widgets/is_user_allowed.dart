import 'package:flutter/material.dart';
import 'package:uber_rider_app/Global/constants.dart';
import 'package:uber_rider_app/Models/user_model.dart';

class CheckUser extends StatelessWidget {
  final Widget? child;
  final Widget? notAllowedWidget;
  final Widget Function(bool)? allowedWidget;
  const CheckUser(
      {Key? key, this.child, this.notAllowedWidget, this.allowedWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: getAuthProvider(context).isUserAllowedGetter,
        builder: (_, user, __) {
          if (user) {
            return child ?? allowedWidget!(user);
          } else {
            return ValueListenableBuilder<UserModel?>(
              valueListenable: getAuthProvider(context).userGetter,
              builder: (_, user, __) =>
                  notAllowedWidget ??
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      user == null
                          ? "You are Logged Out Please Login"
                          : "Abrar you are not Allowed to Order a ride Please Verify your Phone",
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: FONT_BOLT_REGULAR,
                        color: TXT_COLOR_WARNING,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
            );
          }
        });
  }
}
