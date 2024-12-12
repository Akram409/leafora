import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafora/components/shared/utils/screen_size.dart';
import 'package:leafora/components/shared/widgets/custom_card.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:leafora/firebase_database_dir/models/disease.dart';
import 'package:leafora/firebase_database_dir/models/disease_type.dart';
import 'package:leafora/firebase_database_dir/service/disease_service.dart';
import 'package:leafora/firebase_database_dir/service/disease_type_service.dart';

class DiagnosePage extends StatefulWidget {
  const DiagnosePage({super.key});

  @override
  State<DiagnosePage> createState() => _DiagnosePageState();
}

class _DiagnosePageState extends State<DiagnosePage> {
  final DiseaseService diseaseService = DiseaseService();
  final DiseaseTypeService diseaseTypeService = DiseaseTypeService();

  // Disease Categories Data
  List<Map<String, String>> diseaseCategories = [
    {
      'title': 'Fungal',
      'image': 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg'
    },
    {
      'title': 'Bacterial',
      'image': 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg'
    },
    {
      'title': 'Viral',
      'image': 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg'
    },
    {
      'title': 'Pests',
      'image': 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg'
    },
    {
      'title': 'Environmental',
      'image': 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg'
    },
  ];


  @override
  Widget build(BuildContext context) {

    var screenWidth = ScreenSize.width(context);
    var gapHeight1 = 20.0;
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: gapHeight1),

              CustomCard(
                lottieAssetName: 'assets/images/plant-disease.json',
                title: 'Check Your Plant',
                description: 'Take photos start diagnose deceases & get plant care tips',
                buttonText: 'Diagnosis',
                nextPage: '/plant-disease',
              ),

              SizedBox(height: gapHeight1),

              // Common Diseases Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Common Diseases',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/commonDiseaseList');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ' View All',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_outlined,
                          size: screenWidth * 0.04,
                          color: Colors.greenAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: gapHeight1),

              // Dynamic Horizontal List of Diseases
              StreamBuilder<List<DiseaseModel>>(
                stream: diseaseService.streamAllDiseases(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5, // Number of skeletons to show
                        itemBuilder: (context, index) => DiseaseSkeletonCard(),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No diseases found.'));
                  }

                  List<DiseaseModel> diseases = snapshot.data!;
                  print("Diseases: ${diseases.map((disease) => disease.diseaseName ?? 'No Name').toList()}");

                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: diseases.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DiseaseCard(
                            disease: diseases[index],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),


              SizedBox(height: gapHeight1),

              CustomCard(
                lottieAssetName: 'assets/images/growth.json',
                title: 'Check Plant Genus',
                description: 'Take photos & find plant Genus',
                buttonText: 'Check Genus..',
                nextPage: '/plant-genus',
              ),

              SizedBox(height: gapHeight1),
              // Explore Diseases Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Explore Diseases',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                     Get.toNamed('/exploreDiseaseList');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ' View All',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_outlined,
                          size: screenWidth * 0.04,
                          color: Colors.greenAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: gapHeight1),

              // Explore Plants Grid
              StreamBuilder<List<DiseaseTypeModel>>(
                stream: diseaseTypeService.streamAllDiseaseTypes(),
                builder: (context, snapshot) {
                  // Handle loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 4, // Number of skeleton cards to show
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3 / 2,
                      ),
                      itemBuilder: (context, index) => DiseaseCategorySkeletonCard(),
                    );
                  }

                  // Handle errors
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  // Handle case when no data is returned
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No disease categories found.'));
                  }

                  // Handle case when data is available
                  List<DiseaseTypeModel> diseaseTypes = snapshot.data!;
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: diseaseTypes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 2,
                    ),
                    itemBuilder: (context, index) {
                      final diseaseType = diseaseTypes[index];

                      return DiseaseCategoryCard(
                        title: diseaseType.diseaseTypeName,
                        imageUrl: diseaseType.diseases.isNotEmpty
                            ? 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg'
                            : 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg',
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
class DiseaseCard extends StatelessWidget {
  final DiseaseModel? disease;

  const DiseaseCard({required this.disease});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        // Navigate to the disease details page with the disease data
        Get.toNamed("/diseaseDetails", arguments: disease);
      },
      child: Container(
        width: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: disease?.diseaseImage ?? 'default_image_url', // Fallback to default image if null
                fit: BoxFit.cover,
                height: 150,
                width: 230,
                placeholder:(context, url) => const CustomLoader2(
                  lottieAsset: 'assets/images/loader.json',
                  size: 60,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: 8),
            Text(
              disease?.diseaseName ?? 'Unknown Disease', // Fallback to 'Unknown Disease'
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.05,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}


class DiseaseSkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: 230,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: 230,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 16,
            width: screenWidth * 0.5,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}

class DiseaseCategoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const DiseaseCategoryCard({
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = ScreenSize.width(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 3),
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder:(context, url) => const CustomLoader2(
                lottieAsset: 'assets/images/loader.json',
                size: 60,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          // Semi-transparent overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Center(
            child: Text(
              title,
              style: GoogleFonts.lora(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class DiseaseCategorySkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 3),
            blurRadius: 4,
          ),
        ],
        color: Colors.grey[300], // Skeleton placeholder color
      ),
      child: Stack(
        children: [
          // Background placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),
          // Semi-transparent overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.1), // Slightly darker overlay
            ),
          ),
          // Centered text placeholder
          Center(
            child: Container(
              width: 100,
              height: 16,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

