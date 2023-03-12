import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:the_country_number/the_country_number.dart';
import 'package:uber_rider_app/Models/user_model.dart';
import 'package:uber_rider_app/Screens/Auth%20Screens/verify_email.dart';
import 'package:uber_rider_app/Screens/page.dart';
import 'package:uber_rider_app/Widgets/custom_textfield.dart';
import 'package:uber_rider_app/Widgets/divider.dart';

import '../../Global/constants.dart';
import '../../Widgets/custom_button.dart';
import '../Auth Screens/phone_verify_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeAreaScreen(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: SPLASH_SCREEN_COLOR,
          elevation: 1,
          title: Text(
            "Edit Profile",
            style: TextStyle(
              fontFamily: FONT_BOLT_BOLD,
              fontSize: FONT_SIZE_16,
              color: TXT_COLOR_LIGHT,
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          width: getSize(context).width > 800
              ? getSize(context).width * 0.3
              : getSize(context).width,
          height: getSize(context).height,
          margin: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: CONTAINER_COLOR_DARK.withOpacity(0.2),
                  child: const Icon(
                    FontAwesomeIcons.user,
                  ),
                ),
                const CustomDivider(
                  height: 16,
                  color: SPLASH_SCREEN_COLOR,
                  indent: 1,
                  endIndent: 1,
                  thickness: 1,
                ),
                ValueListenableBuilder<UserModel?>(
                    valueListenable: getAuthProvider(context).userGetter,
                    builder: (context, user, __) {
                      return Column(
                        children: [
                          customListTile(
                              title: "First Name",
                              subtitle: user?.fname ?? "First Name",
                              onTap: () {
                                pushNewScreen(
                                  context,
                                  EditTextField(
                                    label: "First Name",
                                    onSave: (value) {
                                      showLoadingDialog(context);
                                      getAuthProvider(context).updateValue(
                                        {"fname": value},
                                        UserModel(
                                          fname: value,
                                        ),
                                      ).then((value) {
                                        pop(context);
                                      });
                                    },
                                    validator: ValidationBuilder()
                                        .required("First Name is required")
                                        .build(),
                                    value: user?.fname,
                                  ),
                                );
                              }),
                          customListTile(
                              title: "Last Name",
                              subtitle: user?.lname ?? "Last Name",
                              onTap: () {
                                pushNewScreen(
                                  context,
                                  EditTextField(
                                    label: "Last Name",
                                    onSave: (value) {
                                      showLoadingDialog(context);
                                      getAuthProvider(context).updateValue(
                                        {"lname": value},
                                        UserModel(
                                          lname: value,
                                        ),
                                      ).then((value) {
                                        pop(context);
                                      });
                                    },
                                    validator: ValidationBuilder()
                                        .required("Last Name is required")
                                        .build(),
                                    value: user?.lname,
                                  ),
                                );
                              }),
                          customListTile(
                            title: "Phone",
                            subtitle: user?.phone ?? "Phone",
                            isTrailing: true,
                            onTap: user!.isPhoneVerified!
                                ? () {}
                                : () {
                                    pushNewScreen(
                                      context,
                                      EditTextField(
                                        label: "Phone",
                                        onSave: (value) {
                                          showLoadingDialog(context);
                                          getAuthProvider(context).updateValue(
                                            {"phone": value},
                                            UserModel(
                                              phone: value,
                                            ),
                                          ).then(
                                            (v) {
                                              pop(context);
                                              popAndPushNewScreen(
                                                context,
                                                VerifyPhoneNumberScreen(
                                                  phoneNumber: value,
                                                  linkWithCurrentAccount: true,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        validator: ValidationBuilder()
                                            .phone("Phone Name is required")
                                            .build(),
                                        isPhone: true,
                                        value: user.phone,
                                      ),
                                    );
                                  },
                            trailing: Text(
                              user.isPhoneVerified ?? false
                                  ? "Verified"
                                  : "Not Verified",
                              style: TextStyle(
                                fontFamily: FONT_BOLT_BOLD,
                                fontSize: 16,
                                color: user.isPhoneVerified ?? false
                                    ? Colors.green
                                    : TXT_COLOR_ERROR,
                              ),
                            ),
                          ),
                          customListTile(
                            title: "Email",
                            subtitle: user.email ?? "Email",
                            isTrailing: true,
                            trailing: Text(
                              user.isVerified ?? false
                                  ? "Verified"
                                  : "Not Verified",
                              style: TextStyle(
                                fontFamily: FONT_BOLT_BOLD,
                                fontSize: 16,
                                color: user.isVerified ?? false
                                    ? Colors.green
                                    : TXT_COLOR_ERROR,
                              ),
                            ),
                            onTap: user.isVerified!
                                ? () {}
                                : () {
                                    pushNewScreen(
                                      context,
                                      EditTextField(
                                        label: "Email",
                                        onSave: (email) {
                                          popAndPushNewScreen(
                                            context,
                                            VerifyEmailScreen(email: email),
                                          );
                                        },
                                        validator: ValidationBuilder()
                                            .required("Email Name is required")
                                            .email()
                                            .build(),
                                        value: user.email,
                                      ),
                                    );
                                  },
                          ),
                          customListTile(
                            title: "Password",
                            subtitle: "********",
                            onTap: () {
                              pushNewScreen(
                                context,
                                EditTextField(
                                  label: "Password",
                                  isPassword: true,
                                  onSave: (currentPassword, newPassword) {
                                    log("$currentPassword ==== $newPassword");
                                    try {
                                      showLoadingDialog(context);
                                      getAuthProvider(context)
                                          .updatePassword(
                                        currentPassword: currentPassword,
                                        password: newPassword,
                                        context: context,
                                      )
                                          .then((value) {
                                        if (value) {
                                          pop(context);
                                          pop(context);
                                        } else {
                                          pop(context);
                                        }
                                      });
                                    } catch (e) {
                                      pop(context);
                                    }
                                  },
                                  validator: ValidationBuilder()
                                      .required("Password is required")
                                      .minLength(8)
                                      .build(),
                                  value: "",
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customListTile({
    String? title = "Name",
    String? subtitle = "Name here",
    bool isTrailing = false,
    Widget? trailing,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListTile(
          tileColor: CONTAINER_COLOR_GREY.shade100,
          title: Text(
            title!,
            style: TextStyle(
              fontFamily: FONT_BOLT_REGULAR,
              fontSize: FONT_SIZE_14,
              color: TXT_COLOR_GREY,
            ),
          ),
          trailing: isTrailing ? trailing : null,
          subtitle: Text(
            subtitle!,
            style: TextStyle(
              fontFamily: FONT_BOLT_BOLD,
              fontSize: FONT_SIZE_18,
              color: TXT_COLOR_DARK,
            ),
          ),
        ),
      ),
    );
  }
}

class EditTextField extends StatefulWidget {
  final String? label;
  final String? value;
  final Function onSave;
  final bool isPhone;
  final bool isPassword;
  final String? Function(String?)? validator;
  const EditTextField({
    Key? key,
    required this.label,
    required this.onSave,
    required this.validator,
    this.isPhone = false,
    this.isPassword = false,
    required this.value,
  }) : super(key: key);

  @override
  State<EditTextField> createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode focusNode = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  String initialCountry = "";
  String? completePhone;

  parsePhone() async {
    try {
      final numberString = widget.value!;
      final theNumber =
          TheCountryNumber().parseNumber(internationalNumber: numberString);

      controller.text = theNumber.number;

      setState(() {
        initialCountry = theNumber.country.iso2;
      });
    } on NotANumber catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isPhone) {
      parsePhone();
    } else {
      controller.text = widget.value!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaScreen(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: SPLASH_SCREEN_COLOR,
          elevation: 1,
          title: Text(
            "Edit ${widget.label}",
            style: TextStyle(
              fontFamily: FONT_BOLT_BOLD,
              fontSize: FONT_SIZE_16,
              color: TXT_COLOR_LIGHT,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: formKey,
                  child: widget.isPhone
                      ? IntlPhoneField(
                          focusNode: focusNode,
                          initialCountryCode: initialCountry,
                          controller: controller,
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
                            setState(() {
                              completePhone = phone.completeNumber;
                            });
                            log(phone.completeNumber);
                          },
                        )
                      : widget.isPassword
                          ? Column(
                              children: [
                                CustomTextField(
                                  focusNode: focusNode,
                                  validator: widget.validator,
                                  controller: controller,
                                  label: "Current Password",
                                  sufixIcon: FontAwesomeIcons.circleDot,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomTextField(
                                  focusNode: focusNode2,
                                  validator: widget.validator,
                                  controller: controller2,
                                  label: "New Password",
                                  sufixIcon: FontAwesomeIcons.circleDot,
                                ),
                              ],
                            )
                          : CustomTextField(
                              focusNode: focusNode,
                              validator: widget.validator,
                              controller: controller,
                              label: widget.label!,
                              sufixIcon: FontAwesomeIcons.circleDot,
                            ),
                ),
                const SizedBox(
                  height: 16,
                ),
                UberButton(
                  text: widget.isPhone
                      ? "Verify Phone Number"
                      : widget.label!.toLowerCase().contains("email")
                          ? "Verify Email"
                          : "Save",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (widget.isPassword) {
                        widget.onSave(controller.text, controller2.text);
                      } else {
                        if (widget.isPhone) {
                          widget.onSave(completePhone ?? widget.value!);
                        } else {
                          widget.onSave(controller.text);
                        }
                      }
                    }
                  },
                  flex: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
