import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? width;
  final double? height;
  final TextStyle? textStyle;


  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width,
    this.height,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the default color if none is provided
    final buttonColor = color ?? Theme.of(context).primaryColor;

    // Use a default text style if none is provided
    final buttonTextStyle = textStyle ?? TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: Size(width ?? 150, height ?? 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: buttonTextStyle,
      ),
    );
  }
}
