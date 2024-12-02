import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:leafora/components/pages/user/my_bookmark/pages/bookmark_articles.dart';
import 'package:leafora/components/pages/user/my_bookmark/pages/bookmark_plants.dart';

class MyBookmarkPage extends StatefulWidget {
  const MyBookmarkPage({super.key});

  @override
  State<MyBookmarkPage> createState() => _MyBookmarkPageState();
}

class _MyBookmarkPageState extends State<MyBookmarkPage> {
  static const textStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w500, );
  static const color = Colors.white;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          leadingWidth: screenWidth * 0.10,
          title: Center(
            child: Text(
              "My Bookmark",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                // Bookmark button action
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.greenAccent, // Border color
                    width: 3, // Border width
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TabBar(
                  indicator: ShapeDecoration(
                    color: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.cannabis,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Plants",
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.article_outlined,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Article",
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                children: [BookmarkPlants(), BookmarkArticles()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
