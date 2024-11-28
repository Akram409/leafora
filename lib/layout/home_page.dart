import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:leafora/components/shared/utils/screen_size.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List list = [
    "Flutter",
    "React",
    "Ionic",
    "Xamarin",
  ];
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
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
  int index = 2;
  final items = <Widget>[
    Icon(Icons.add_outlined, size: 30,color: Colors.black),
    Icon(Icons.list, size: 30,color: Colors.black),
    Icon(Icons.compare_arrows, size: 30,color: Colors.black),
  ];
  @override
  Widget build(BuildContext context) {
    var screenWidth = ScreenSize.width(context);
    var gapHeight1 = 20.0;

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        appBar: CustomAppBar(title: 'Lefora'),
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

                // Horizontal List of Articles
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ArticleCard(
                          title: articles[index]['title']!,
                          imageUrl: articles[index]['imageUrl']!,
                        ),
                      );
                    },
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
                GridView.builder(
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
                    final plant = plantCategories[index];
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
                            child: Image.network(
                              plant['image']!,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
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
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(color: Colors.white)
          ),
          child: CurvedNavigationBar(
            key: navigationKey,
            backgroundColor: Colors.transparent,
            color: Colors.greenAccent,
            buttonBackgroundColor: Colors.green,
            index: index,
            height: 70,
            animationCurve: Curves.easeInOut,
            // animationDuration: Duration(microseconds: 400),
            items: items,
            onTap: (index) {
              setState(() {
                this.index = index;
              });
            },
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
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 150,
              width: 200,
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
