import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafora/components/shared/utils/screen_size.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:leafora/firebase_database_dir/models/disease.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../firebase_database_dir/service/disease_service.dart';

class CommonDiseaseList extends StatefulWidget {
  const CommonDiseaseList({Key? key}) : super(key: key);

  @override
  _CommonDiseaseListState createState() => _CommonDiseaseListState();
}

class _CommonDiseaseListState extends State<CommonDiseaseList> {
  final DiseaseService diseaseService = DiseaseService();

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
    var screenWidth = ScreenSize.width(context);
    var gapHeight1 = 20.0;
    return Scaffold(
      appBar: CustomAppBar3(title: "Common Diseases"),
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

          // StreamBuilder with Skeletonizer for loading state
          StreamBuilder<List<DiseaseModel>>(
            stream: diseaseService.streamAllDiseases(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: 5, // Number of skeletons to show
                    itemBuilder: (context, index) => CommonSkeletonCard(),
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
              print(
                  "Diseases: ${diseases.map((disease) => disease.diseaseName ?? 'No Name').toList()}");

              return Expanded(
                child: ListView.builder(
                  itemCount: diseases.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 16.0),
                      child: CommonDiseaseCard(
                        disease: diseases[index],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CommonDiseaseCard extends StatelessWidget {
  final DiseaseModel? disease;

  const CommonDiseaseCard({
    Key? key,
    required this.disease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    if (disease == null) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed("/diseaseDetails",arguments: disease);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 0,
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
                    disease!.diseaseImage ?? 'default_image_url',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 22),
            // Middle: Text Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disease!.diseaseName ?? 'Unknown Disease',
                    style: GoogleFonts.lora(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Right: Arrow Icon
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

class CommonSkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Skeletonizer(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 16.0),
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
