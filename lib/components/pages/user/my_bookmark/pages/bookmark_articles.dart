import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:leafora/firebase_database_dir/service/user_service.dart';
import 'package:leafora/services/auth_service.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookmarkArticles extends StatefulWidget {
  const BookmarkArticles({super.key});

  @override
  State<BookmarkArticles> createState() => _BookmarkArticlesState();
}

class _BookmarkArticlesState extends State<BookmarkArticles> {
  // Articles Data
  List<Map<String, String>> articles = [];
  bool isLoading = true;
  final UserService _userService = UserService();
  final authService = AuthService();

  void fetchBookmarks() {
    // Get the current user and ensure it's not null
    authService.getCurrentUser().then((user) {
      if (user == null) {
        throw Exception("User not logged in");
      }

      String userId = user.uid;

      // Use the Stream of bookmarks from UserService
      _userService.getBookmarks(userId, 'article').listen((bookmarks) {
        // Filter and map the data for articles
        final filteredArticles = bookmarks.map((bookmark) {
          return {
            'title': bookmark['bookmarkName']?.toString() ?? '',
            'imageUrl': bookmark['bookmarkImage']?.toString() ?? '',
            'bookmarkId': bookmark['bookmarkId']?.toString() ?? '',
          };
        }).toList();

        setState(() {
          articles = filteredArticles;
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
    Future.delayed(Duration(seconds: 2), () {
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
        child: articles.isEmpty
            ? Center(
          child: Lottie.asset(
            "assets/images/noData.json",
            fit: BoxFit.cover,
            repeat: true,
          ),
        )
            :ListView.builder(
          itemCount: isLoading ? 5 : articles.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: isLoading
                  ? ArticleCardSkeleton() // Show skeleton card when loading
                  : ArticleCard(
                      title: articles[index]['title']!,
                      imageUrl: articles[index]['imageUrl']!,
                bookmarkId: articles[index]['bookmarkId']!,
                    ),
            );
          },
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String bookmarkId;

  const ArticleCard({required this.title, required this.imageUrl,required this.bookmarkId});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        Get.toNamed("/articleDetailsById", arguments: bookmarkId);
      },
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                height: 200,
                width: screenWidth,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.more_vert_rounded,
                  size: screenWidth * 0.05,
                  color: Colors.black26,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Skeletonizer(
      child: Column(
        children: [
          Container(
            width: screenWidth,
            height: 200,
            color: Colors.grey[300],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 20,
                  width: screenWidth * 0.6,
                  color: Colors.grey[300],
                ),
              ),
              Icon(
                Icons.more_vert_rounded,
                size: screenWidth * 0.05,
                color: Colors.black26,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
