import 'package:flutter/material.dart';

import '../Global/constants.dart';

class CheckAddressAdded extends StatelessWidget {
  final Widget? child;
  final Widget? notAllowedWidget;
  final Widget Function(bool)? allowedWidget;
  const CheckAddressAdded({
    Key? key,
    this.allowedWidget,
    this.child,
    this.notAllowedWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: getAddressProvider(context).getIsAddressSetNotifier,
        builder: (_, isSet, __) {
          if (isSet) {
            return child ?? allowedWidget!(isSet);
          } else {
            return notAllowedWidget ?? Container();
          }
        });
  }
}
