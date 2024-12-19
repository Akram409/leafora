import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class UpgradePlanMessage extends StatelessWidget {
  const UpgradePlanMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(
                FontAwesomeIcons.crown,
                size: 70, // Fixed size for better UI
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Upgrade Unlocked!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Welcome to Lefora Pro",
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "Benefits Unlocked",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // List of premium features
            Column(

              children:  [
                FeatureItem(icon: Icons.done_all_rounded, text: "Unlimited access to Pro features"),
                FeatureItem(icon: Icons.done_all_rounded, text: "Unlimited disease & genus check"),
                FeatureItem(icon: Icons.done_all_rounded, text: "24/7 Expert Support"),
                FeatureItem(icon: Icons.done_all_rounded, text: "Exclusive content and updates"),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Thank you for choosing Lifora Pro support. Your support helps us grow and contribute providing the best plant loving experience.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black45),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Close and Navigate button
            ElevatedButton(
              onPressed: () {
                Get.toNamed("/home");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              child: const Text(
                "Go to Home",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
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
      padding: const EdgeInsets.symmetric(vertical: 5.0,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          FittedBox(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
