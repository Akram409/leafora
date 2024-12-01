import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:leafora/components/pages/diagnose/diagnose_page.dart';
import 'package:leafora/components/pages/home/home_pages.dart';
import 'package:leafora/components/shared/utils/screen_size.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  int currentIndex = 0;
  final items = <Widget>[
    Icon(Icons.home_outlined, size: 30,color: Colors.white),
    Icon(Icons.shield_outlined, size: 30,color: Colors.white),
    Icon(FontAwesomeIcons.userDoctor, size: 30,color: Colors.white),
    Icon(FontAwesomeIcons.plantWilt, size: 30,color: Colors.white),
    Icon(Icons.person, size: 30,color: Colors.white),
  ];

  final List<Widget> pages = [
    HomePages(),
    DiagnosePage(),
    HomePages(),
    HomePages(),
    HomePages(),
  ];

  final List<String> titles = [
    'Home',
    'Shield',
    'Diagnose',
    'Plants',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    var screenWidth = ScreenSize.width(context);
    var gapHeight1 = 20.0;

    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(title: titles[currentIndex]),
      body: pages[currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.white)
        ),
        child: CurvedNavigationBar(
          key: navigationKey,
          backgroundColor: Colors.transparent,
          color: Colors.greenAccent,
          buttonBackgroundColor: Colors.blue,
          index: currentIndex,
          height: 70,
          animationCurve: Curves.easeInOut,
          // animationDuration: Duration(microseconds: 400),
          items: items,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}


