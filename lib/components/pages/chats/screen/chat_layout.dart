import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        //app bar
        appBar: AppBar(
          //title
          title: Text('We Chat'),
          actions: [
            //search user button
            IconButton(
                tooltip: 'Search',
                onPressed: () {},
                icon: Icon(CupertinoIcons.search)),

            IconButton(
                tooltip: 'Add User',
                padding: const EdgeInsets.only(right: 8),
                onPressed: () {},
                icon: const Icon(CupertinoIcons.person_add, size: 25))
          ],
        ),

        //floating button to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {},

          ),


        ),
      ),
    );
  }
}
