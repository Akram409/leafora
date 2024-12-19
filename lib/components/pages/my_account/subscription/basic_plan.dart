import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafora/components/shared/utils/screen_size.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';

class BasicPlan extends StatefulWidget {
  final UserModel? user;
  const BasicPlan({super.key, this.user});

  @override
  State<BasicPlan> createState() => _BasicPlanState();
}

class _BasicPlanState extends State<BasicPlan> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    bool isBasicPlan = widget.user?.plan == 'basic';
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Lefora Basic",
                        style: GoogleFonts.lora(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.lora(
                            fontSize: screenWidth * 0.15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '\u{09F3}0', // Assuming you want to show the cost
                              style: GoogleFonts.lora(
                                fontSize: screenWidth * 0.15,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            TextSpan(
                              text: '/month',
                              style: GoogleFonts.lora(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade300, thickness: 1),
                // Features
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FeatureItem(
                          icon: Icons.done_all_rounded,
                          text: "Daily 5 credit to disease & genus check",
                          color: Colors.green),
                      FeatureItem(
                          icon: Icons.cancel_outlined,
                          text: "Unlimited access to Pro features",
                          color: Colors.red),
                      FeatureItem(
                          icon: Icons.cancel_outlined,
                          text: "24/7 Expert Support Services.",
                          color: Colors.red),
                      FeatureItem(
                          icon: Icons.cancel_outlined,
                          text: "Exclusive content and updates",
                          color: Colors.red),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBasicPlan ? Colors.grey : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: isBasicPlan ? null : () {
                      Get.toNamed("/paymentMethod");
                    },
                    child: Text(
                      isBasicPlan ? 'Current Plan: Basic' : 'Continue - \u{09F3}0',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const FeatureItem({super.key, required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    var screenWidth = ScreenSize.width(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          FittedBox(
            child: Text(
              text,
              style:  TextStyle(fontSize: screenWidth*0.05),
            ),
          ),
        ],
      ),
    );
  }
}
