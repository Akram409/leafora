import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookmarkArticles extends StatefulWidget {
  const BookmarkArticles({super.key});

  @override
  State<BookmarkArticles> createState() => _BookmarkArticlesState();
}

class _BookmarkArticlesState extends State<BookmarkArticles> {
  // Articles Data
  List<Map<String, String>> articles = [
    {
      'title': 'Unlock the Secrets of Succulents: Care Tips for Beginners',
      'imageUrl': 'https://i.ibb.co/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg',
    },
    {
      'title': 'The Ultimate Guide to Indoor Plants: From A to Z',
      'imageUrl': 'https://i.ibb.co/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg',
    },
    {
      'title': 'Why You Should Start Growing Your Own Herbs at Home',
      'imageUrl': 'https://i.ibb.co/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg',
    },
    {
      'title': 'Top 10 Indoor Plants That Thrive in Low Light',
      'imageUrl': 'https://i.ibb.co/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg',
    },
    {
      'title': 'How to Care for Orchids: Tips from Experts',
      'imageUrl': 'https://i.ibb.co/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg',
    },
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a loading delay
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
        enableSwitchAnimation: true,  // Adds animation when switching from skeleton to content
        child: ListView.builder(
          itemCount: isLoading ? 5 : articles.length, // Show 5 skeleton items when loading
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: isLoading
                  ? ArticleCardSkeleton()  // Show skeleton card when loading
                  : ArticleCard(
                title: articles[index]['title']!,
                imageUrl: articles[index]['imageUrl']!,
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

  const ArticleCard({required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
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
