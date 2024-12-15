import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:leafora/components/pages/my_plants/diagnosis_history/my_diagnosis_history.dart';
import 'package:leafora/components/pages/my_plants/plants/my_plants_page.dart';

class MyPlants extends StatefulWidget {
  const MyPlants({super.key});

  @override
  State<MyPlants> createState() => _MyPlantsState();
}

class _MyPlantsState extends State<MyPlants> {
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: Center(
              child: Container(
                width: screenWidth * 0.85,
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.greenAccent,
                    width: 2,
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
                            "My Posts",
                            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500, ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_enhance_outlined,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Snap",
                            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500, ),
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
                children: [MyPlantsPage(), MyDiagnosisHistory()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
