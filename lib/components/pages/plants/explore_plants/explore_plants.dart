import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:leafora/components/shared/utils/screen_size.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:leafora/firebase_database_dir/models/plant.dart';
import 'package:leafora/firebase_database_dir/service/plant_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExplorePlants extends StatefulWidget {
  const ExplorePlants({super.key});

  @override
  State<ExplorePlants> createState() => _ExplorePlantsState();
}

class _ExplorePlantsState extends State<ExplorePlants> {
  final PlantService _plantService = PlantService();
  List list = [
    "Flutter",
    "React",
    "Ionic",
    "Xamarin",
  ];

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
    var gapHeight1 = 10.0;
    return Scaffold(
      appBar: CustomAppBar3(title: "Explore Plants"),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Skeletonizer(
                enabled: isLoading,
                enableSwitchAnimation: true,
                child: StreamBuilder<List<PlantModel>>(
                  stream: _plantService.getAllPlantsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 6, // Skeleton items count
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3 / 2,
                        ),
                        itemBuilder: (context, index) {
                          return PlantCategorySkeleton();
                        },
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Failed to load plant categories.'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No plant categories available.'));
                    }

                    // Get the plant categories from the snapshot data
                    final plantCategories = snapshot.data!;
                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: plantCategories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3 / 2,
                      ),
                      itemBuilder: (context, index) {
                        final plantCategory = plantCategories[index];
                        return PlantCategoryItem(
                          plant: plantCategory,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class PlantCategoryItem extends StatelessWidget {
  final PlantModel plant;

  const PlantCategoryItem({required this.plant});

  @override
  Widget build(BuildContext context) {
    var screenWidth = ScreenSize.width(context);
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
          Text(
            plant.plantName!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.03,
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