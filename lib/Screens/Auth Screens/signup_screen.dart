import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_rider_app/Global/constants.dart';
import 'package:uber_rider_app/Screens/Auth%20Screens/login_screen.dart';
import 'package:uber_rider_app/Screens/Auth%20Screens/phone_verify_screen.dart';
import 'package:uber_rider_app/Screens/page.dart';

import '../../Models/user_model.dart';
import '../../Services/Data Provider/cloud_functions.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/custom_textfield.dart';
import '../../Widgets/message_widget.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "/signup";
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  String countryCode = "";

  bool showError = false;

  ShowMessage _showMessage = const ShowMessage();

  void signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showLoadingDialog(context);
      try {
        log(countryCode + _phoneController.text.trim());
        CloudFunctions()
            .checkIfPhoneExists(countryCode + _phoneController.text.trim())
            .then((value) {
          log(value.toString());
          Navigator.of(context).pop();
          if (value["exists"]) {
            setState(() {
              showError = true;
              _showMessage = ShowMessage(
                message: value["message"].toString(),
                state: MessageState.error,
                title: "Phone Already Exists",
              );
            });
          } else {
            showLoadingDialog(context);
            getAuthProvider(context)
                .signUp(
              _emailController.text.trim(),
              _passwordController.text.trim(),
              UserModel(
                uid: null,
                displayName:
                    "${_firstName.text.trim()} ${_lastName.text.trim()}",
                fname: _firstName.text.trim(),
                lname: _lastName.text.trim(),
                email: _emailController.text.trim(),
                isVerified: false,
                isPhoneVerified: false,
                phone: countryCode + _phoneController.text.trim(),
                token: "",
                role: "rider",
              ),
            )
                .then((user) async {
              if (user) {
                pop(context);
                popAndPushNewScreen(
                  context,
                  VerifyPhoneNumberScreen(
                    phoneNumber: countryCode + _phoneController.text.trim(),
                    linkWithCurrentAccount: true,
                    isProfileScreen: false,
                  ),
                );
              }
            });
          }
        });
      } catch (e) {
        pop(context);
        setState(() {
          showError = true;
          _showMessage = ShowMessage(
            message: e.toString(),
            state: MessageState.error,
            title: "Error",
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaScreen(
      child: Scaffold(
          backgroundColor: getBackgroundColor(context),
          body: Center(
            child: SizedBox(
              height: getSize(context).height,
              width: getSize(context).width > 1000
                  ? getSize(context).width * 0.3
                  : getSize(context).width,
              child: ListView(
                shrinkWrap: true,
                children: [
                  !showError ? SizedBox(height: (1.5).h) : const SizedBox(),
                  Image(
                    height: 20.h,
                    width: 20.h,
                    alignment: Alignment.center,
                    image: const AssetImage(
                      LOGO,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    RIDER_SIGNUP_TEXT,
                    style: TextStyle(
                      fontSize: FONT_SIZE_22,
                      fontFamily: FONT_BOLT_BOLD,
                      color: TXT_COLOR_DARK,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  showError ? _showMessage : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 48),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  focusNode: _firstNameFocusNode,
                                  focusNextNode: _lastNameFocusNode,
                                  controller: _firstName,
                                  validator: ValidationBuilder()
                                      .minLength(2,
                                          "First Name must be at least 2 characters")
                                      .build(),
                                  label: "First Name",
                                  iconSize: 10,
                                  sufixIcon: FontAwesomeIcons.userLarge,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: CustomTextField(
                                  focusNode: _lastNameFocusNode,
                                  focusNextNode: _emailFocusNode,
                                  controller: _lastName,
                                  validator: ValidationBuilder()
                                      .minLength(2,
                                          "Last Name must be at least 2 characters")
                                      .build(),
                                  label: "Last Name",
                                  iconSize: 10,
                                  sufixIcon: FontAwesomeIcons.userLarge,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            focusNode: _emailFocusNode,
                            focusNextNode: _passwordFocusNode,
                            controller: _emailController,
                            validator: ValidationBuilder()
                                .email("Please enter correct email")
                                .build(),
                            label: "Email",
                            sufixIcon: FontAwesomeIcons.at,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            focusNode: _passwordFocusNode,
                            focusNextNode: _phoneFocusNode,
                            controller: _passwordController,
                            validator: ValidationBuilder()
                                .minLength(
                                    8, "Password must be at least 8 characters")
                                .build(),
                            label: "Password",
                            sufixIcon: FontAwesomeIcons.key,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          IntlPhoneField(
                            focusNode: _phoneFocusNode,
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: BORDER_COLOR_DARK,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(
                                    TEXTFIELD_BORDER_RADIUS),
                              ),
                              floatingLabelStyle:
                                  const TextStyle(color: TXT_COLOR_DARK),
                              focusColor: Colors.black,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: BORDER_COLOR_DARK,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(
                                    TEXTFIELD_BORDER_RADIUS),
                              ),
                              suffixIcon: const Icon(
                                FontAwesomeIcons.phone,
                                size: 14,
                                color: ICON_COLOR_DARK,
                              ),
                            ),
                            dropdownIcon: const Icon(
                              FontAwesomeIcons.caretDown,
                              color: ICON_COLOR_DARK,
                              size: 16,
                            ),
                            flagsButtonPadding: const EdgeInsets.all(16),
                            showDropdownIcon: false,
                            onChanged: (phone) {
                              log(phone.completeNumber);
                            },
                            onCountryChanged: (country) {
                              log('Country changed to: ${country.dialCode}');
                              setState(() {
                                countryCode = "+${country.dialCode}";
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          UberButton(
                            onPressed: () => signUp(context),
                            text: "Sign Up",
                          ),
                          const SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                fontFamily: FONT_BOLT_REGULAR,
                                fontSize: FONT_SIZE_16,
                                color: TXT_COLOR_DARK,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign In",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      popAndPushNewScreen(
                                          context, const LoginScreen());
                                    },
                                  style: TextStyle(
                                    fontFamily: FONT_BOLT_BOLD,
                                    fontSize: FONT_SIZE_16,
                                    color: TXT_COLOR_DARK,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
