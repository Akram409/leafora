import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:leafora/firebase_database_dir/models/diagnosis.dart';
import 'package:leafora/firebase_database_dir/service/diagnosis_service.dart';
import 'package:leafora/services/auth_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyDiagnosisHistory extends StatefulWidget {
  const MyDiagnosisHistory({super.key});

  @override
  State<MyDiagnosisHistory> createState() => _MyDiagnosisHistoryState();
}

class _MyDiagnosisHistoryState extends State<MyDiagnosisHistory> {
  final AuthService _authService = AuthService();
  final DiagnosisService _diagnosisService = DiagnosisService();
  List<DiagnosisModel> diagnosisHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDiagnosisHistory();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> fetchDiagnosisHistory() async {
    try {
      // Get the current logged-in user
      var user = await _authService.getCurrentUser();
      if (user != null) {
        // Fetch diagnoses filtered by userId
        List<DiagnosisModel> diagnoses =
            await _diagnosisService.getDiagnosesByUserId(user.uid);

        setState(() {
          diagnosisHistory = diagnoses;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("No user is logged in.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching diagnosis history: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Skeletonizer(
        enabled: isLoading,
        enableSwitchAnimation: true,
        child: diagnosisHistory.isEmpty
            ? Center(
                child: isLoading
                    ? CustomLoader2(
                        lottieAsset: 'assets/images/loader.json',
                        size: 60,
                      )
                    : const Text("No Diagnosis History Found"),
              )
            : ListView.builder(
                itemCount: diagnosisHistory.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final diagnosis = diagnosisHistory[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: isLoading
                        ? DiagnosisHistoryCardSkeleton()
                        : DiagnosisHistoryCard(
                            diagnosis:
                                diagnosis,
                            onTap: () {
                              Get.toNamed(
                                "/diagnosisHistoryDetails",
                                arguments:
                                    diagnosis,
                              );
                            },
                          ),
                  );
                },
              ),
      ),
    );
  }
}

class DiagnosisHistoryCard extends StatelessWidget {
  final DiagnosisModel diagnosis;
  final VoidCallback onTap;

  const DiagnosisHistoryCard({
    Key? key,
    required this.diagnosis,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Left: Square Picture
            Container(
              width: screenWidth * 0.23,
              height: screenWidth * 0.23,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    (diagnosis.diagnosisImage != null &&
                            diagnosis.diagnosisImage!.containsKey('url'))
                        ? diagnosis.diagnosisImage!['url']!
                        : 'https://via.placeholder.com/150',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
            // Middle: Text Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diagnosis.diagnosisName,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    diagnosis.diagnosisType,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    diagnosis.checkAt,
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      fontStyle: FontStyle.italic,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagnosisHistoryCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Skeletonizer(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Left: Square Placeholder Picture
            Container(
              width: screenWidth * 0.23,
              height: screenWidth * 0.23,
              color: Colors.grey[300],
            ),
            const SizedBox(width: 22),
            // Middle: Text Column with placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: screenWidth * 0.5,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 7),
                  Container(
                    height: 15,
                    width: screenWidth * 0.4,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 7),
                  Container(
                    height: 15,
                    width: screenWidth * 0.3,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
            // Right: Placeholder Arrow Icon
            const Icon(
              Icons.arrow_forward,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
