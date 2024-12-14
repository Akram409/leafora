import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:leafora/firebase_database_dir/models/diagnosis.dart';

class DiagnosisHistoryDetails extends StatefulWidget {
  const DiagnosisHistoryDetails({super.key});

  @override
  State<DiagnosisHistoryDetails> createState() => _DiagnosisHistoryDetailsState();
}

class _DiagnosisHistoryDetailsState extends State<DiagnosisHistoryDetails> {
  final DiagnosisModel diagnosis = Get.arguments;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar5(title: "Diagnosis Details"),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: (diagnosis.diagnosisImage != null &&
                  diagnosis.diagnosisImage!.containsKey('url'))
                  ? diagnosis.diagnosisImage!['url']!
                  : 'https://via.placeholder.com/150',
              width: screenWidth,
              height: 250,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CustomLoader2(
                lottieAsset: 'assets/images/loader.json',
                size: 60,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 16),
          // Diagnosis Details
          Text(
            "Type: ${diagnosis.diagnosisType.toUpperCase()}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Snap At: ${diagnosis.checkAt}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          // Additional Info
          Text(
            "Details:",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Markdown(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            data: diagnosis.diagnosisResults ?? "No additional details available.",
          ),
        ],
      ),
    );
  }
}
