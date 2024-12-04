import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyPlantsPage extends StatefulWidget {
  const MyPlantsPage({super.key});

  @override
  State<MyPlantsPage> createState() => _MyPlantsPageState();
}

class _MyPlantsPageState extends State<MyPlantsPage> {
  final List<Map<String, String>> plants = List.generate(10, (index) {
    return {
      'title': 'Plant Title $index',
      'semiTitle': 'Semi-title $index',
      'genusName': 'Genus $index',
      'imageUrl': 'https://i.ibb.co/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg',
    };
  });

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
    return Scaffold(
      body: Skeletonizer(
        enabled: isLoading,
        enableSwitchAnimation: true,
        child: ListView.builder(
          itemCount: isLoading ? 5 : plants.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: isLoading
                  ? BookmarkPlantCardSkeleton()
                  : BookmarkPlantCard(
                title: plants[index]['title']!,
                semiTitle: plants[index]['semiTitle']!,
                genusName: plants[index]['genusName']!,
                imageUrl: plants[index]['imageUrl']!,
              ),
            );
          },
        ),
      ),
    );
  }
}

class BookmarkPlantCard extends StatefulWidget {
  final String title;
  final String semiTitle;
  final String genusName;
  final String imageUrl;

  const BookmarkPlantCard({
    Key? key,
    required this.title,
    required this.semiTitle,
    required this.genusName,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<BookmarkPlantCard> createState() => _BookmarkPlantCardState();
}

class _BookmarkPlantCardState extends State<BookmarkPlantCard> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Get.toNamed("/plantDetails"); // TODO : set the arguments here to see details of the plants
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
                  image: CachedNetworkImageProvider(widget.imageUrl),
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
                    widget.title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    widget.semiTitle,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    widget.genusName,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontStyle: FontStyle.italic,
                      color: Colors.green,
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

class BookmarkPlantCardSkeleton extends StatelessWidget {
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
