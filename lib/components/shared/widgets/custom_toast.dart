import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void show(
      String message, {
        Color bgColor = Colors.black,
        Color textColor = Colors.white,
        ToastGravity gravity = ToastGravity.BOTTOM,
      }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }
}

class CustomToast2 {
  static void show(
      BuildContext context,
      String message, {
        Color bgColor = Colors.black,
        Color textColor = Colors.white,
      }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: textColor,
        ),
      ),
      backgroundColor: bgColor,
      duration: const Duration(seconds: 2),
    );

    // Display the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
