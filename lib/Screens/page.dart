import 'package:flutter/cupertino.dart';

class SafeAreaScreen extends StatelessWidget {
  final Widget child;
  const SafeAreaScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: child,
    );
  }
}
