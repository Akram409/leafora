import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:leafora/firebase_database_dir/service/user_service.dart';
import 'package:leafora/services/auth_service.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookmarkPlants extends StatefulWidget {
  const BookmarkPlants({super.key});

  @override
  State<BookmarkPlants> createState() => _BookmarkPlantsState();
}

class _BookmarkPlantsState extends State<BookmarkPlants> {
  final UserService _userService = UserService();
  final authService = AuthService();
  List<Map<String, String>> plants = [];

  bool isLoading = true;
  void fetchBookmarks() {
    // Get the current user and ensure it's not null
    authService.getCurrentUser().then((user) {
      if (user == null) {
        throw Exception("User not logged in");
      }

      String userId = user.uid;

      // Use the Stream of bookmarks from UserService
      _userService.getBookmarks(userId, 'plant').listen((bookmarks) {
        // Filter and map the data for plants
        final filteredPlants = bookmarks.map((bookmark) {
          return {
            'title': bookmark['bookmarkName']?.toString() ?? '',
            'imageUrl': bookmark['bookmarkImage']?.toString() ?? '',
            'plantScientificName': bookmark['plantScientificName']?.toString() ?? '',
            'plantGenus': bookmark['plantGenus']?.toString() ?? '',
            'bookmarkId': bookmark['bookmarkId']?.toString() ?? '',
          };
        }).toList();

        setState(() {
          plants = filteredPlants;
        });
      });
    }).catchError((e) {
      print("Error fetching bookmarks: $e");
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }


  @override
  void initState() {
    super.initState();
    // Simulate a loading delay
    fetchBookmarks();
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
        child: plants.isEmpty
            ? Center(
          child: Lottie.asset(
            "assets/images/noData.json",
            fit: BoxFit.cover,
            repeat: true,
          ),
        )
            :ListView.builder(
          itemCount: isLoading ? 5 : plants.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: isLoading
                  ? BookmarkPlantCardSkeleton()
                  : BookmarkPlantCard(
                title: plants[index]['title']!,
                plantScientificName: plants[index]['plantScientificName']!,
                plantGenus: plants[index]['plantGenus']!,
                imageUrl: plants[index]['imageUrl']!,
                bookmarkId: plants[index]['bookmarkId']!,
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
  final String plantScientificName;
  final String plantGenus;
  final String imageUrl;
  final String bookmarkId;

  const BookmarkPlantCard({
    Key? key,
    required this.title,
    required this.plantScientificName,
    required this.plantGenus,
    required this.imageUrl,
    required this.bookmarkId,
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
        Get.toNamed("/plantDetailsById", arguments: widget.bookmarkId);
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
                    widget.plantScientificName,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    widget.plantGenus,
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
