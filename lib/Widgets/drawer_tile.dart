import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_rider_app/Global/constants.dart';

class UberTile extends StatelessWidget {
  const UberTile(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onTap,
      this.isEmergency = false,
      this.color = TXT_COLOR_LIGHT})
      : super(key: key);

  final String title;
  final IconData icon;
  final void Function() onTap;
  final bool isEmergency;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Material(
        color: CONTAINER_COLOR_LIGHT.withOpacity(0.02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TILE_BORDER_RADIUS),
        ),
        child: InkWell(
          onTap: onTap,
          splashColor: SPLASH_COLOR_LIGHT.withOpacity(0.1),
          child: Container(
            height: 100,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CONTAINER_COLOR_LIGHT.withOpacity(0.02),
              borderRadius: BorderRadius.circular(TILE_BORDER_RADIUS),
            ),
            padding:
                const EdgeInsets.only(top: 16, left: 5, right: 5, bottom: 16),
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Icon(
                  icon,
                  color: isEmergency ? Colors.red : color,
                  size: kIsWeb ? 14.sp : 18.sp,
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: FONT_SIZE_16,
                      fontFamily: FONT_BOLT_BOLD,
                      color: isEmergency ? Colors.red : color,
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
