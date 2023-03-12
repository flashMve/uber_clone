import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uber_rider_app/Global/constants.dart';
import 'package:uber_rider_app/Models/user_model.dart';
import 'package:uber_rider_app/Screens/page.dart';
import 'package:uber_rider_app/Widgets/custom_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  late bool isEmailVerified;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = getAuthProvider(context).auth.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerifcation();
      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    }
  }

  sendVerifcation() {
    getAuthProvider(context).sendVerificationLink();
  }

  checkEmailVerified() {
    getAuthProvider(context).auth.currentUser?.reload();

    setState(() {
      isEmailVerified =
          getAuthProvider(context).auth.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer.cancel();
      getAuthProvider(context).updateEmail(email: widget.email);
      getAuthProvider(context).updateValue(
        {"isVerified": true},
        UserModel(isVerified: true),
      ).then((value) {
        pop(context);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaScreen(
      child: Scaffold(
        backgroundColor: getBackgroundColor(context),
        body: Center(
          child: Container(
            alignment: Alignment.center,
            width: getSize(context).width > 800
                ? getSize(context).width * 0.3
                : getSize(context).width,
            height: getSize(context).height,
            padding: const EdgeInsets.all(16),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.s,
              children: [
                Image.asset("assets/images/verify.png"),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "We have sent an email verification link to your email (${widget.email}). \n\n Please Verify by Clicking on the link.",
                  style: const TextStyle(
                    color: TXT_COLOR_DARK,
                    fontSize: 20,
                    fontFamily: FONT_BOLT_BOLD,
                  ),
                  textAlign: TextAlign.center,
                  // textScaleFactor: 1,
                ),
                const SizedBox(
                  height: 32,
                ),
                UberButton(
                  onPressed: () {
                    sendVerifcation();
                  },
                  text: "Resend Email",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
