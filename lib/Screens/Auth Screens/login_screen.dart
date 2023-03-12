import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validator/form_validator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_rider_app/Global/constants.dart';
import 'package:uber_rider_app/Screens/Auth%20Screens/signup_screen.dart';
import 'package:uber_rider_app/Screens/Home%20Screens/home_screen.dart';
import 'package:uber_rider_app/Screens/page.dart';
import 'package:uber_rider_app/Services/Data%20Provider/cloud_functions.dart';
import 'package:uber_rider_app/Widgets/custom_button.dart';
import 'package:uber_rider_app/Widgets/custom_textfield.dart';
import 'package:uber_rider_app/Widgets/message_widget.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _passwordFocusNode = FocusNode();

  bool showError = false;
  ShowMessage _showMessage = const ShowMessage();

  void login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showLoadingDialog(context);
      try {
        CloudFunctions()
            .checkIfRiderOrDriver(_emailController.text, "rider")
            .then((result) async {
          pop(context);
          if (result["allowed"]) {
            showLoadingDialog(context);
            await getAuthProvider(context)
                .login(_emailController.text.trim(),
                    _passwordController.text.trim())
                .then((user) async {
              pop(context);
              if (user != null) {
                popAndPushNewScreen(context, const HomeScreen());
              }
            });
          } else {
            showSnackBar(message: result["message"]);
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
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: SizedBox(
            height: getSize(context).height,
            width: kIsWeb
                ? getSize(context).width > 800
                    ? getSize(context).width * 0.3
                    : getSize(context).width
                : getSize(context).width,
            child: ListView(
              shrinkWrap: true,
              children: [
                !showError ? const SizedBox(height: 35) : const SizedBox(),
                Image(
                  height: 30.h,
                  width: 30.h,
                  alignment: Alignment.center,
                  image: const AssetImage(
                    LOGO,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  RIDER_LOGIN_TEXT,
                  style: TextStyle(
                    fontSize: FONT_SIZE_22,
                    fontFamily: FONT_BOLT_BOLD,
                    color: TXT_COLOR_DARK,
                  ),
                  textAlign: TextAlign.center,
                ),
                showError ? _showMessage : Container(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          focusNextNode: _passwordFocusNode,
                          validator: ValidationBuilder()
                              .email("Please enter correct email")
                              .build(),
                          label: "Email",
                          sufixIcon: FontAwesomeIcons.at,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          validator: ValidationBuilder()
                              .minLength(
                                  8, "Password must be at least 8 characters")
                              .build(),
                          obscureText: true,
                          label: "Password",
                          sufixIcon: FontAwesomeIcons.key,
                        ),
                        const SizedBox(height: 20),
                        UberButton(
                            onPressed: () => login(context), text: "Login"),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              fontFamily: FONT_BOLT_REGULAR,
                              fontSize: FONT_SIZE_16,
                              color: TXT_COLOR_DARK,
                            ),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    pushNewScreen(
                                        context, const SignUpScreen());
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
        ),
      ),
    );
  }
}
