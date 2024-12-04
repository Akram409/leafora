import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafora/components/authentication/login_screen.dart';
import 'package:leafora/components/authentication/welcome_screen.dart';
import 'package:leafora/firebase_database_dir/models/onboarding.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimatedOnboardingScreen extends StatefulWidget {
  const AnimatedOnboardingScreen({super.key});

  @override
  State<AnimatedOnboardingScreen> createState() =>
      _AnimatedOnboardingScreenState();
}

class _AnimatedOnboardingScreenState extends State<AnimatedOnboardingScreen> {
  final PageController pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomPaint(
            painter: ArcPaint(),
            child: SizedBox(
              height: size.height / 1.35,
              width: size.width,
            ),
          ),
          // for lottie animation file
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            right: 0,
            left: 0,
            child: Lottie.asset(OnboardingItem[currentIndex].lottieURL,
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.9,
                 alignment: Alignment.topCenter),
          ),
          // for scrolling
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 270,
              child: Column(
                children: [
                  Flexible(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: OnboardingItem.length,
                      itemBuilder: (context, index) {
                        final items = OnboardingItem[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 10),
                          child: Column(
                            children: [
                              Text(
                                items.title,
                                textAlign: TextAlign.center ,
                                style: GoogleFonts.lora(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                items.subtitle,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoCondensed(
                                  fontSize: 15,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onPageChanged: (value) {
                        setState(() {
                          currentIndex = value;
                        });
                      },
                    ),
                  ),
                  // dot indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int index = 0;
                      index < OnboardingItem.length;
                      index++)
                        dotIndicator(isSelected: index == currentIndex),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);

        // Check if it's the last onboarding page
        if (currentIndex == OnboardingItem.length - 1) {
          // Save the flag indicating that the user has seen the onboarding
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('hasSeenOnboarding', true);

          Get.toNamed("/welcome");
        }
      },
        elevation: 0,
        backgroundColor: Colors.white,
        child: const Icon(Icons.arrow_forward_ios,color:Colors.green),
      ),
    );
  }

  Widget dotIndicator({required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: AnimatedContainer(
        duration: const Duration(microseconds: 500),
        height: isSelected ? 8 : 6,
        width: isSelected ? 8 : 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.green : Colors.greenAccent,
        ),
      ),
    );
  }
}

class ArcPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path orangeArc = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 175)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - 175)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(orangeArc, Paint()..color = Colors.green);

    Path whiteArc = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, size.height - 180)
      ..quadraticBezierTo(
          size.width / 2, size.height - 60, size.width, size.height - 180)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(
      whiteArc,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
