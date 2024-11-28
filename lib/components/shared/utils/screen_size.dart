import 'package:flutter/material.dart';

class ScreenSize {
  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width; // Requires Flutter 3.13+
  }

  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static double aspectRatio(BuildContext context) {
    return MediaQuery.sizeOf(context).aspectRatio;
  }
}
