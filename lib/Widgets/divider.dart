import 'package:flutter/material.dart';
import 'package:uber_rider_app/Global/constants.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key? key,
    this.color,
    this.endIndent = 10,
    this.thickness = 1,
    this.indent = 10,
    this.height = 0,
  }) : super(key: key);
  final Color? color;
  final double height;
  final double indent;
  final double endIndent;
  final double thickness;
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? CONTAINER_COLOR_LIGHT.withOpacity(0.5),
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      height: height,
    );
  }
}
