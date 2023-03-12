import 'package:flutter/material.dart';

import '../Global/constants.dart';

class InfoWindowsCustom extends StatelessWidget {
  const InfoWindowsCustom({
    Key? key,
    required this.time,
    required this.address,
  }) : super(key: key);

  final String? time;
  final String? address;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS),
      ),
      width: 200,
      height: 30,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            width: 50,
            height: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
              ),
              color: CONTAINER_COLOR_DARK,
            ),
            child: Text(
              time!,
              style: TextStyle(
                color: TXT_COLOR_LIGHT,
                fontSize: FONT_SIZE_14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Flexible(
            child: SizedBox(
              child: Text(
                address!,
                style: TextStyle(
                  color: TXT_COLOR_DARK,
                  fontSize: FONT_SIZE_14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
          )
        ],
      ),
    );
  }
}
