import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader extends StatelessWidget {
  final Color color;
  final double size;

  const CustomLoader({
    Key? key,
    this.color = Colors.greenAccent,
    this.size = 80.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitHourGlass(
        color: color,
        size: size,
      ),
    );
  }
}
