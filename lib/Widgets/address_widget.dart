import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_rider_app/Global/constants.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget({
    Key? key,
    String title = "Home",
    String address = "123 Main St",
    IconData icon = FontAwesomeIcons.house,
    this.submit,
  })  : _title = title,
        _address = address,
        _icon = icon,
        super(key: key);

  final String _title;
  final String _address;
  final IconData _icon;
  final Function? submit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Material(
        color: CONTAINER_COLOR_GREY.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS),
        ),
        child: InkWell(
          onTap: () => submit!(),
          child: Container(
            decoration: BoxDecoration(
              color: CONTAINER_COLOR_GREY.shade100,
              borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _icon,
                  size: 16.sp,
                  color: ICON_COLOR_DARK,
                ),
                const SizedBox(width: 20),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title,
                        style: TextStyle(
                          fontSize: FONT_SIZE_16,
                          fontFamily: FONT_BOLT_REGULAR,
                          color: TXT_COLOR_DARK,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _address,
                        style: TextStyle(
                          fontSize: FONT_SIZE_16,
                          fontFamily: FONT_BOLT_REGULAR,
                          color: TXT_COLOR_DARK,
                        ),
                        maxLines: 5,
                        softWrap: true,
                      ),
                    ],
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
