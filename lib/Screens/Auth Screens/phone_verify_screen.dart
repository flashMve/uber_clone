import 'dart:developer';

import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pinput/pinput.dart';
import 'package:uber_rider_app/Global/constants.dart';
import 'package:uber_rider_app/Models/user_model.dart';
import 'package:uber_rider_app/Screens/Home%20Screens/home_screen.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  final String phoneNumber;
  final bool linkWithCurrentAccount;
  final bool isProfileScreen;

  const VerifyPhoneNumberScreen({
    Key? key,
    required this.phoneNumber,
    this.linkWithCurrentAccount = false,
    this.isProfileScreen = false,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;

  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
  }

  // scroll to bottom of screen, when pin input field is in focus.
  Future<void> _scrollToBottomOnKeyboardOpen() async {
    while (!isKeyboardVisible) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    await Future.delayed(const Duration(milliseconds: 250));

    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FirebasePhoneAuthHandler(
          phoneNumber: widget.phoneNumber,
          signOutOnSuccessfulVerification: false,
          linkWithExistingUser: widget.linkWithCurrentAccount,
          autoRetrievalTimeOutDuration: const Duration(seconds: 60),
          otpExpirationDuration: const Duration(seconds: 60),
          onCodeSent: () {
            log('OTP sent!');
          },
          recaptchaVerifierForWebProvider: (isWeb) {
            // if (isWeb) {
            //   return RecaptchaVerifier(

            //                     container: 'recaptcha',
            //     size: RecaptchaVerifierSize.compact,
            //     theme: RecaptchaVerifierTheme.dark,
            //     onSuccess: () => log('reCAPTCHA Completed!'),
            //     onError: (FirebaseAuthException error) => log(error.toString()),
            //     onExpired: () => log('reCAPTCHA Expired!'),
            //   );
            // }
            return null;
          },
          onLoginSuccess: (userCredential, autoVerified) async {
            getAuthProvider(context).updateValue(
              {"isPhoneVerified": true},
              UserModel(isPhoneVerified: true),
            ).then((value) {
              if (widget.isProfileScreen) {
                pop(context);
              } else {
                popAndPushNewScreen(
                  context,
                  const HomeScreen(),
                );
              }
            });
          },
          onLoginFailed: (authException, stackTrace) {},
          onError: (error, stackTrace) {},
          builder: (context, controller) {
            return Scaffold(
              appBar: AppBar(
                leadingWidth: 0,
                leading: const SizedBox.shrink(),
                backgroundColor: SPLASH_SCREEN_COLOR,
                title: const Text('Verify Phone Number'),
                actions: [
                  if (controller.codeSent)
                    TextButton(
                      onPressed: controller.isOtpExpired
                          ? () async {
                              await controller.sendOTP();
                            }
                          : null,
                      child: Text(
                        controller.isOtpExpired
                            ? 'Resend'
                            : '${controller.otpExpirationTimeLeft.inSeconds}s',
                        style: const TextStyle(
                            color: TXT_COLOR_LIGHT, fontSize: 18),
                      ),
                    ),
                  const SizedBox(width: 5),
                ],
              ),
              body: controller.isSendingCode
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LoadingBouncingGrid.square(
                          size: 30,
                          backgroundColor: SPLASH_SCREEN_COLOR,
                        ),
                        const SizedBox(height: 50),
                        const Center(
                          child: Text(
                            'Sending OTP',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: SizedBox(
                        width: getSize(context).width > 800
                            ? getSize(context).width * 0.3
                            : getSize(context).width,
                        height: getSize(context).height,
                        child: ListView(
                          padding: const EdgeInsets.all(20),
                          controller: scrollController,
                          children: [
                            Text(
                              "We've sent an SMS with a verification code to ${widget.phoneNumber}",
                              style: const TextStyle(fontSize: 25),
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            if (controller.isListeningForOtpAutoRetrieve)
                              Column(
                                children: [
                                  LoadingBouncingGrid.square(
                                    size: 30,
                                    backgroundColor: SPLASH_SCREEN_COLOR,
                                  ),
                                  const SizedBox(height: 50),
                                  const Text(
                                    'Listening for OTP',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Divider(),
                                  const Text('OR', textAlign: TextAlign.center),
                                  const Divider(),
                                ],
                              ),
                            const SizedBox(height: 15),
                            const Text(
                              'Enter OTP',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 15),
                            PinInputField(
                              length: 6,
                              onFocusChange: (hasFocus) async {
                                if (hasFocus)
                                  await _scrollToBottomOnKeyboardOpen();
                              },
                              onSubmit: (enteredOtp) async {
                                final verified =
                                    await controller.verifyOtp(enteredOtp);
                                if (verified) {
                                  // number verify success
                                  // will call onLoginSuccess handler
                                } else {
                                  // phone verification failed
                                  // will call onLoginFailed or onError callbacks with the error
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          }),
    );
  }
}

class PinInputField extends StatefulWidget {
  final int length;
  final void Function(bool)? onFocusChange;
  final void Function(String) onSubmit;

  const PinInputField({
    Key? key,
    this.length = 6,
    this.onFocusChange,
    required this.onSubmit,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PinInputFieldState createState() => _PinInputFieldState();
}

class _PinInputFieldState extends State<PinInputField> {
  late final TextEditingController _pinPutController;
  late final FocusNode _pinPutFocusNode;
  late final int _length;

  Size _findContainerSize(BuildContext context) {
    // full screen width
    double width = MediaQuery.of(context).size.width * 0.85;

    // using left-over space to get width of each container
    width /= _length;

    return Size.square(width);
  }

  @override
  void initState() {
    _pinPutController = TextEditingController();
    _pinPutFocusNode = FocusNode();

    if (widget.onFocusChange != null) {
      _pinPutFocusNode.addListener(() {
        widget.onFocusChange!(_pinPutFocusNode.hasFocus);
      });
    }

    _length = widget.length;
    super.initState();
  }

  @override
  void dispose() {
    _pinPutController.dispose();
    _pinPutFocusNode.dispose();
    super.dispose();
  }

  PinTheme _getPinTheme(
    BuildContext context, {
    required Size size,
  }) {
    return PinTheme(
      height: size.height,
      width: size.width,
      textStyle: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: TXT_COLOR_DARK,
      ),
      decoration: BoxDecoration(
        color: CONTAINER_COLOR_GREY.shade200,
        borderRadius: BorderRadius.circular(7.5),
      ),
    );
  }

  static const _focusScaleFactor = 1.15;

  @override
  Widget build(BuildContext context) {
    final size = _findContainerSize(context);
    final defaultPinTheme = _getPinTheme(context, size: size);

    return SizedBox(
      height: size.height * _focusScaleFactor,
      child: Pinput(
        length: _length,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: defaultPinTheme.copyWith(
          height: size.height * _focusScaleFactor,
          width: size.width * _focusScaleFactor,
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: CONTAINER_COLOR_DARK),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: TXT_COLOR_ERROR,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        focusNode: _pinPutFocusNode,
        controller: _pinPutController,
        onCompleted: widget.onSubmit,
        pinAnimationType: PinAnimationType.scale,
        // submittedFieldDecoration: _pinPutDecoration,
        // selectedFieldDecoration: _pinPutDecoration,
        // followingFieldDecoration: _pinPutDecoration,
        // textStyle: const TextStyle(
        //   color: Colors.black,
        //   fontSize: 20.0,
        //   fontWeight: FontWeight.w600,
        // ),
      ),
    );
  }
}
