import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class K {
  static Color mainColor = Colors.blueGrey.shade900;
  static Color backgroundColor = Colors.blueGrey.shade800;
  static const Color yellowColor = Color(0xFFDDB837);
  static const Color splashBackground = Color(0xFF8DCADA);

  static SnackBar customSnackBar(String content) {
    return SnackBar(
      content: Text(
        content,
        style: const TextStyle(color: Colors.white),
      ),
      elevation: 4,
      behavior: SnackBarBehavior.floating,
      backgroundColor: mainColor,
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  }
}
