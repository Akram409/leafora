import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:leafora/components/pages/my_account/subscription/basic_plan.dart';
import 'package:leafora/components/pages/my_account/subscription/pro_plan.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    // Get the user data from Get.arguments
    currentUser = Get.arguments as UserModel?;
  }

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
              "Upgrade Plan",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Center(
              child: Container(
                width: screenWidth * 0.85,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                          Text(
                            "Basic",
                            style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.crown,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Pro",
                            style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w500),
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
                children: [
                  BasicPlan(user: currentUser),
                  ProPlan(user: currentUser),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
