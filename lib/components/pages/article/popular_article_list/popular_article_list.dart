import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leafora/components/shared/utils/screen_size.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:leafora/firebase_database_dir/models/article.dart';
import 'package:leafora/firebase_database_dir/service/article_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PopularArticleList extends StatefulWidget {
  const PopularArticleList({super.key});

  @override
  State<PopularArticleList> createState() => _PopularArticleListState();
}

class _PopularArticleListState extends State<PopularArticleList> {
  final ArticleService _articleService = ArticleService();
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
    });

    // Simulate a loading delay
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(searchQuery);
    var screenWidth = ScreenSize.width(context);
    var gapHeight1 = 10.0;
    return Scaffold(
      appBar: CustomAppBar(title: "Popular Article"),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: gapHeight1),
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search article...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),

            Skeletonizer(
              enabled: isLoading ,
              enableSwitchAnimation: true,
              child: StreamBuilder<List<ArticleModel>>(
                stream: isLoading
                    ? _articleService.getAllArticlesStream()
                    : _articleService.getFilteredArticlesStream(searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5, // Simulating loading 5 skeleton items
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: ArticleCardSkeleton(),
                        );
                      },
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Failed to load articles.'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No articles found.'));
                  }

                  // Display filtered or all articles
                  final articles = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: articles.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ArticleCard(
                          article: article,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final ArticleModel article;

  const ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          "/articleDetails",
          arguments: article,
        );
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
                imageUrl: article.articleImage,
                fit: BoxFit.cover,
                height: 200,
                width: screenWidth,
                placeholder: (context, url) => const CustomLoader2(
                  lottieAsset: 'assets/images/loader.json',
                  size: 60,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    article.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Icon(
                //   Icons.more_vert_rounded,
                //   size: screenWidth * 0.05,
                //   color: Colors.black26,
                // ),
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
