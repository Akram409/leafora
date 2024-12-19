import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';

class ProPlan extends StatefulWidget {
  final UserModel? user;
  const ProPlan({super.key, this.user});

  @override
  State<ProPlan> createState() => _ProPlanState();
}

class _ProPlanState extends State<ProPlan> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    bool isProPlan = widget.user?.plan == 'pro';
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
                        "Lefora Pro",
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
                              text: '\u{09F3}1', // Unicode for Bangladeshi Taka symbol
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
                      FeatureItem(icon: Icons.done_all_rounded, text: "Unlimited access to Pro features"),
                      FeatureItem(icon: Icons.done_all_rounded, text: "Unlimited disease & genus check"),
                      FeatureItem(icon: Icons.done_all_rounded, text: "24/7 Expert Support Services."),
                      FeatureItem(icon: Icons.done_all_rounded, text: "Exclusive content and updates"),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isProPlan ? Colors.grey : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: isProPlan ? null : () {
                      Get.toNamed("/paymentMethod");
                    },
                    child: Text(
                      isProPlan ? 'Current Plan: Pro' : 'Continue - \u{09F3}0',
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
  const FeatureItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          FittedBox(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
