import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafora/components/shared/utils/screen_size.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:leafora/firebase_database_dir/models/disease_type.dart';
import 'package:leafora/firebase_database_dir/service/disease_type_service.dart';

class ExploreDiseasesList extends StatefulWidget {
  const ExploreDiseasesList({super.key});

  @override
  State<ExploreDiseasesList> createState() => _ExploreDiseasesListState();
}

class _ExploreDiseasesListState extends State<ExploreDiseasesList> {
  final DiseaseTypeService diseaseTypeService = DiseaseTypeService();

  List<String> list = [
    "Flutter",
    "React",
    "Ionic",
    "Xamarin",
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a loading delay
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var gapHeight1 = 20.0;
    return Scaffold(
      appBar: CustomAppBar3(title: "Explore Diseases"),
      body: Column(
        children: [
          SizedBox(height: gapHeight1),

          // Search Bar
          GFSearchBar(
            searchList: list,
            searchQueryBuilder: (query, list) {
              return list
                  .where((item) =>
                  item.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            },
            overlaySearchListItemBuilder: (item) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 18),
                ),
              );
            },
            onItemSelected: (item) {
              setState(() {
                print('$item');
              });
            },
          ),

          // StreamBuilder with ListView.builder for loading state
          StreamBuilder<List<DiseaseTypeModel>>(
            stream: diseaseTypeService.streamAllDiseaseTypes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: 5, // Number of skeletons to show
                    itemBuilder: (context, index) => DiseaseCategorySkeletonCard(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No disease categories found.'));
              }

              List<DiseaseTypeModel> diseaseTypes = snapshot.data!;

              return Expanded(
                child: ListView.builder(
                  itemCount: diseaseTypes.length,
                  itemBuilder: (context, index) {
                    final diseaseType = diseaseTypes[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      child: DiseaseCategoryCard(
                        title: diseaseType.diseaseTypeName,
                        imageUrl: diseaseType.diseases.isNotEmpty
                            ? 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg'
                            : 'https://i.ibb.co.com/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg',
                      ),
                    );
                  },
                ),
              );
            },
          )
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
    return GestureDetector(
      onTap: (){
        Get.toNamed('/categoryDiseaseList',arguments: title);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.23,
              height: screenWidth * 0.23,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.lora(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                ),
              ),
            ),
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

class DiseaseCategorySkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth * 0.23,
            height: screenWidth * 0.23,
            color: Colors.grey[300],
          ),
          const SizedBox(width: 22),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
