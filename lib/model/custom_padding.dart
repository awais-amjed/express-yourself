import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

class CustomPadding extends StatelessWidget {
  const CustomPadding({Key? key, required this.child}) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: child,
    );
  }
}
