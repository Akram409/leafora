import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:leafora/components/pages/article/article_details/article_details.dart';
import 'package:leafora/components/shared/utils/screen_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:leafora/components/shared/widgets/custom_card.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:leafora/firebase_database_dir/models/article.dart';
import 'package:leafora/firebase_database_dir/models/plant.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';
import 'package:leafora/firebase_database_dir/service/article_service.dart';
import 'package:leafora/firebase_database_dir/service/plant_service.dart';
import 'package:leafora/services/auth_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  // Load user data from Firebase or your service
  Future<void> _loadCurrentUser() async {
    try {
      UserModel? user = await _authService.getCurrentUserData();
      setState(() {
        _currentUser = user;
      });
      // Print user details after loading
      if (user != null) {
        print("Current User: ${user.toJson()}");
      } else {
        print("No user data available.");
      }
    } catch (e) {
      print("Error loading current user data: $e");
    }
  }

  final ArticleService _articleService = ArticleService();
  final PlantService _plantService = PlantService();

  List list = [
    "Flutter",
    "React",
    "Ionic",
    "Xamarin",
  ];

  // Plant Categories Data
  List<Map<String, String>> plantCategories = [
    {
      'title': 'Succulents & Cacti',
      'image': 'https://i.ibb.co.com/WHz0bWq/pngwing-com.png'
    },
    {
      'title': 'Flowering Plants',
      'image': 'https://i.ibb.co.com/WHz0bWq/pngwing-com.png'
    },
    {
      'title': 'Foliage Plants',
      'image': 'https://i.ibb.co.com/WHz0bWq/pngwing-com.png'
    },
    {'title': 'Trees', 'image': 'https://i.ibb.co.com/WHz0bWq/pngwing-com.png'},
    {
      'title': 'Weeds & Shrubs',
      'image': 'https://i.ibb.co.com/WHz0bWq/pngwing-com.png'
    },
    {
      'title': 'Fruits',
      'image': 'https://i.ibb.co.com/WHz0bWq/pngwing-com.png'
    },
  ];

  bool isLoading = true;


  @override
  Widget build(BuildContext context) {
    var screenWidth = ScreenSize.width(context);
    var gapHeight1 = 20.0;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              SizedBox(height: gapHeight1),

              // Popular Articles Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Articles',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed("/popularArticle");
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

              // Horizontal List of Articles
              StreamBuilder<List<ArticleModel>>(
                stream: _articleService.getAllArticlesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Skeletonizer(
                      enabled: true,
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return ArticleCardSkeleton();
                          },
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Failed to load articles.'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No articles found.'),
                    );
                  }

                  final articles = snapshot.data!;
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return  ArticleCard(article: article);
                      },
                    ),
                  );
                },
              ),

              SizedBox(height: gapHeight1),

              CustomCard2(
                lottieAssetName: 'assets/images/expert.json',
                title: 'Ask Plant Expert',
                description: 'Our botanist are ready to help with your problems',
                buttonText: 'Ask the Experts',
                nextPage: _currentUser?.role == "expert" ? '/askPlantExpert' : '/subscription',
              ),

              SizedBox(height: gapHeight1),
              // Explore Plants Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Explore Plants',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed("/explorePlants");
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
              StreamBuilder<List<PlantModel>>(
                stream: _plantService.getAllPlantsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Wrap the grid with Skeletonizer while loading
                    return Skeletonizer(
                      enabled: true,
                      enableSwitchAnimation: true,
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 6, // Skeleton items
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3 / 2,
                        ),
                        itemBuilder: (context, index) {
                          return PlantCategorySkeleton();
                        },
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Failed to load plants.'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No plants found.'),
                    );
                  }

                  final plants = snapshot.data!;
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: plants.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 2,
                    ),
                    itemBuilder: (context, index) {
                      final plant = plants[index];
                      return PlantCategoryItem(
                        plant: plant,
                      );
                    },
                  );
                },
              ),
            ],
          ),
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
        Get.to(ArticleDetails(), arguments: article);
      },
      child: Container(
        width: 200,
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
                height: 150,
                width: 200,
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
    return Container(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 150,
            color: Colors.grey[300],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 20,
                  color: Colors.grey[300],
                ),
              ),
              Icon(
                Icons.more_vert_rounded,
                color: Colors.black26,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlantCategoryItem extends StatelessWidget {
  final PlantModel plant;

  const PlantCategoryItem({required this.plant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Example: Get.toNamed("/plantDetails", arguments: plant);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Plant image from dynamic data (URL)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: plant.plantImage!,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CustomLoader2(
                  lottieAsset: 'assets/images/loader.json',
                  size: 60,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: 8),
            // Plant title from dynamic data
            Text(
              plant.plantName!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


class PlantCategorySkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            color: Colors.grey[300],
          ),
          SizedBox(height: 8),
          Container(
            height: 14,
            width: 100,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
