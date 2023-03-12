import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Global/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required TextEditingController controller,
    IconData sufixIcon = FontAwesomeIcons.envelope,
    String label = "Email",
    required String? Function(String?)? validator,
    bool obscureText = false,
    bool enabled = true,
    double iconSize = 14,
    this.focusNode,
    this.focusNextNode,
    this.onPressed,
  })  : _controller = controller,
        _sufixIcon = sufixIcon,
        _label = label,
        _validator = validator,
        _obscureText = obscureText,
        _iconSize = iconSize,
        _enabled = enabled,
        super(key: key);

  final TextEditingController _controller;
  final FocusNode? focusNode;
  final FocusNode? focusNextNode;
  final IconData _sufixIcon;
  final String _label;
  final String? Function(String?)? _validator;
  final Function? onPressed;
  final bool _obscureText;
  final bool _enabled;
  final double _iconSize;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      enabled: _enabled,
      focusNode: focusNode,
      obscureText: _obscureText,
      validator: _validator,
      onFieldSubmitted: (value) {
        if (focusNextNode != null) {
          focusNextNode!.requestFocus();
        } else {
          focusNode!.unfocus();
        }
      },
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      onEditingComplete: () {},
      style: TextStyle(
          fontFamily: FONT_BOLT_REGULAR,
          fontSize: FONT_SIZE_16 - 1,
          color: TXT_COLOR_DARK),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: _label,
        labelStyle: TextStyle(
            fontFamily: FONT_BOLT_REGULAR,
            fontSize: FONT_SIZE_16 - 1,
            color: TXT_COLOR_DARK),
        errorMaxLines: 2,
        suffixIcon: Icon(
          _sufixIcon,
          size: _iconSize,
          color: ICON_COLOR_DARK,
        ),
        floatingLabelStyle: const TextStyle(color: TXT_COLOR_DARK),
        focusColor: FOCUS_COLOR_DARK,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TEXTFIELD_BORDER_RADIUS),
          borderSide: const BorderSide(
            color: BORDER_COLOR_DARK,
            width: 1,
          ),
        ),
        fillColor: FILL_COLOR_DARK,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TEXTFIELD_BORDER_RADIUS),
          borderSide: const BorderSide(
            color: BORDER_COLOR_DARK,
            width: 1,
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldOnly extends StatelessWidget {
  const CustomTextFieldOnly({
    Key? key,
    required TextEditingController controller,
    IconData sufixIcon = FontAwesomeIcons.envelope,
    String label = "Email",
    required Function(String?)? submit,
    bool obscureText = false,
    bool enabled = true,
    Function(String)? onChange,
    double iconSize = 14,
    String hint = "",
    this.focusNode,
    this.focusNextNode,
    this.onPressed,
  })  : _controller = controller,
        _sufixIcon = sufixIcon,
        _label = label,
        _submit = submit,
        _obscureText = obscureText,
        _iconSize = iconSize,
        _enabled = enabled,
        _hint = hint,
        _onChange = onChange,
        super(key: key);

  final TextEditingController _controller;
  final FocusNode? focusNode;
  final FocusNode? focusNextNode;
  final IconData _sufixIcon;
  final String _label;
  final String _hint;
  final Function(String?)? _submit;
  final Function(String)? _onChange;
  final Function? onPressed;
  final bool _obscureText;
  final bool _enabled;
  final double _iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null && !_enabled) {
          log("In here GESTURE_DETECTOR");
          onPressed!();
        }
      },
      child: TextField(
        controller: _controller,
        enabled: _enabled,
        focusNode: focusNode ?? FocusNode(),
        obscureText: _obscureText,
        autofocus: false,
        onSubmitted: _submit,
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        onEditingComplete: () {
          focusNode?.unfocus();
        },
        onChanged: (value) {
          if (_onChange != null) {
            _onChange!(value);
          }
        },
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.name,
        cursorColor: CURSOR_COLOR_DARK,
        style: TextStyle(
            fontFamily: FONT_BOLT_REGULAR,
            fontSize: FONT_SIZE_16 - 1,
            color: TXT_COLOR_DARK),
        decoration: InputDecoration(
          labelText: _label,
          labelStyle: TextStyle(
              fontFamily: FONT_BOLT_REGULAR,
              fontSize: FONT_SIZE_16 - 1,
              color: TXT_COLOR_DARK),
          hintStyle: TextStyle(
            fontFamily: FONT_BOLT_REGULAR,
            fontSize: FONT_SIZE_16 - 1,
            color: TXT_COLOR_DARK,
          ),
          errorMaxLines: 2,
          hintText: _hint,
          suffixIcon: Icon(
            _sufixIcon,
            size: _iconSize.sp,
            color: ICON_COLOR_DARK,
          ),
          floatingLabelStyle: const TextStyle(color: TXT_COLOR_DARK),
          focusColor: FOCUS_COLOR_DARK,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TEXTFIELD_BORDER_RADIUS),
            borderSide: const BorderSide(
              color: BORDER_COLOR_DARK,
              width: 1,
            ),
          ),
          fillColor: FILL_COLOR_DARK,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TEXTFIELD_BORDER_RADIUS),
            borderSide: const BorderSide(
              color: BORDER_COLOR_DARK,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
