// import 'dart:async';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:leafora/components/shared/widgets/loading_indicator.dart';
// import 'package:leafora/services/auth_service.dart';
//
// class Splash extends StatefulWidget {
//   const Splash({super.key});
//
//   @override
//   State<Splash> createState() => _SplashState();
// }
//
// class _SplashState extends State<Splash> {
//   final AuthService _authService = AuthService();
//
//   void startTimer() async {
//     User? user = await _authService.getCurrentUser();
//
//     Timer(const Duration(seconds: 5), () async {
//     });
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               child: Column(
//                 children: [
//                   Image.asset(
//                     "assets/images/bus_koi.png",
//                     height: MediaQuery.sizeOf(context).width * 0.7,
//                     width: MediaQuery.sizeOf(context).width * 0.7,
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             const CustomLoader(color: Colors.greenAccent, size: 80.0),
//           ],
//         ),
//       ),
//     );
//   }
// }
