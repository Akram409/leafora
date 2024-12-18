import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafora/components/authentication/login_screen.dart';
import 'package:leafora/components/onBoarding/animated_onboarding.dart';
import 'package:leafora/components/shared/widgets/loading_indicator.dart';
import 'package:leafora/layout/home_page.dart';
import 'package:leafora/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() async {
    User? user = await _authService.getCurrentUser();

    Timer(const Duration(seconds: 5), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

      if (hasSeenOnboarding) {
        if (user != null) {
          String? role = await _authService.getUserRole(user.uid);
          // print("her role is: ${role}");
          if (role != null) {
            switch (role) {
              case 'admin':
                // Get.offAll(() => AdminDashboard());
                break;
              case 'expert':
                // Get.offAll(() => ExpertDashboard());
                break;
              case 'user':
                Get.offAll(() => HomePage());
                break;
              default:
                print("Unknown role: $role");
                Get.offAll(() => LoginScreen());
                break;
            }
          } else {
            // Handle case where role is not found
            print("User role not found.");
            Get.offAll(() => LoginScreen());
          }
        } else {
          Get.offAll(() => LoginScreen());
        }
      } else {
        Get.offAll(() => const AnimatedOnboardingScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/lefora.png",
                    height: MediaQuery.sizeOf(context).width * 0.55,
                    width: MediaQuery.sizeOf(context).width * 0.55,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      Colors.green,
                      Colors.greenAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  "Lefora",
                  style: GoogleFonts.pirataOne(
                    fontSize: MediaQuery.sizeOf(context).width * 0.15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const CustomLoader(color: Colors.greenAccent, size: 50.0),
          ],
        ),
      ),
    );
  }
}
