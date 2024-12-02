import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:leafora/components/shared/utils/screen_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  List list = [
    "Flutter",
    "React",
    "Ionic",
    "Xamarin",
  ];

  // Articles Data
  List<Map<String, String>> articles = [
    {
      'title': 'Unlock the Secrets of Succulents: Care Tips for Beginners',
      'imageUrl': 'https://i.ibb.co.com/5M46jVS/placeholder-image.jpg',
    },
    {
      'title': 'The Ultimate Guide to Indoor Plants: From A to Z',
      'imageUrl': 'https://i.ibb.co.com/5M46jVS/placeholder-image.jpg',
    },
    {
      'title': 'Why You Should Start Growing Your Own Herbs at Home',
      'imageUrl': 'https://i.ibb.co.com/5M46jVS/placeholder-image.jpg',
    },
    {
      'title': 'Top 10 Indoor Plants That Thrive in Low Light',
      'imageUrl': 'https://i.ibb.co.com/5M46jVS/placeholder-image.jpg',
    },
    {
      'title': 'How to Care for Orchids: Tips from Experts',
      'imageUrl': 'https://i.ibb.co.com/5M46jVS/placeholder-image.jpg',
    },
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
              Skeletonizer(
                enabled: isLoading,
                enableSwitchAnimation: true,
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: isLoading ? 5 : articles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: isLoading
                            ? ArticleCardSkeleton()
                            : ArticleCard(
                          title: articles[index]['title']!,
                          imageUrl: articles[index]['imageUrl']!,
                        ),
                      );
                    },
                  ),
                ),
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
              Skeletonizer(
                enabled: isLoading,
                enableSwitchAnimation: true,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: isLoading ? 6 : plantCategories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 2,
                  ),
                  itemBuilder: (context, index) {
                    return isLoading
                        ? PlantCategorySkeleton()
                        : PlantCategoryItem(
                      plant: plantCategories[index],
                    );
                  },
                ),
              ),
            ],
          ),
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
              imageUrl: imageUrl,
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
  final Map<String, String> plant;

  const PlantCategoryItem({required this.plant});

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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: plant['image']!,
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
          Text(
            plant['title']!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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