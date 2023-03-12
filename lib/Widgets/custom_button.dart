import 'package:flutter/material.dart';

import '../Global/constants.dart';

class UberButton extends StatelessWidget {
  const UberButton(
      {Key? key,
      required void Function() onPressed,
      String text = "Sign Up",
      this.flex = 1})
      : _onPressed = onPressed,
        _text = text,
        super(key: key);
  final void Function() _onPressed;
  final String _text;
  final int flex;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            BTN_COLOR_DARK,
          ),
          fixedSize: MaterialStateProperty.all(
            const Size(double.maxFinite, 50),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
        ),
        onPressed: _onPressed,
        child: Text(
          _text,
          style: TextStyle(
            fontFamily: FONT_BOLT_BOLD,
            fontSize: FONT_SIZE_18,
            color: TXT_COLOR_LIGHT,
          ),
        ),
      ),
    );
  }
}

class NonFlexUberButton extends StatelessWidget {
  const NonFlexUberButton({
    Key? key,
    required void Function() onPressed,
    String text = "Sign Up",
    this.backGroundColor = BTN_COLOR_DARK,
    this.textColor = TXT_COLOR_LIGHT,
  })  : _onPressed = onPressed,
        _text = text,
        super(key: key);
  final void Function() _onPressed;
  final String _text;
  final Color? backGroundColor;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          backGroundColor,
        ),
        fixedSize: MaterialStateProperty.all(
          const Size(double.maxFinite, 50),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
      onPressed: _onPressed,
      child: Text(
        _text,
        style: TextStyle(
          fontFamily: FONT_BOLT_BOLD,
          fontSize: FONT_SIZE_18,
          color: textColor,
        ),
      ),
    );
  }
}
