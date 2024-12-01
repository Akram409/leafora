import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafora/components/shared/utils/screen_size.dart';
import 'package:leafora/components/shared/widgets/custom_card.dart';

class DiagnosePage extends StatefulWidget {
  const DiagnosePage({super.key});

  @override
  State<DiagnosePage> createState() => _DiagnosePageState();
}

class _DiagnosePageState extends State<DiagnosePage> {

  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  // Common Diseases Data
  List<Map<String, String>> diseases = [
    {
      'title': 'Mildew',
      'imageUrl': 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg',
    },
    {
      'title': 'Spot',
      'imageUrl': 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg',
    },
    {
      'title': 'Rot',
      'imageUrl': 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg',
    },
    {
      'title': 'Curl',
      'imageUrl': 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg',
    },
    {
      'title': 'Rust',
      'imageUrl': 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg',
    },
  ];

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
                      // Handle 'View All' action
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

              // Horizontal List of disease
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: diseases.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DiseaseCard(
                        title: diseases[index]['title']!,
                        imageUrl: diseases[index]['imageUrl']!,
                      ),
                    );
                  },
                ),
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
                      // Handle 'View All' action
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
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: diseaseCategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  final plant = diseaseCategories[index];
                  return DiseaseCategoryCard(
                    imageUrl: plant['image']!,
                    title: plant['title']!,
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
  final String title;
  final String imageUrl;

  const DiseaseCard({required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
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
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              height: 150,
              width: 230,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.start,
            style: GoogleFonts.lora(
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * 0.05,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}