import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
class CustomLoader1 extends StatelessWidget {
  final Color color;
  final double size;

  const CustomLoader1({
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


class CustomLoader2 extends StatelessWidget {
  final String lottieAsset;
  final String? message;
  final double size;

  const CustomLoader2({
    Key? key,
    required this.lottieAsset,
    this.message,
    this.size = 150.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            lottieAsset,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}