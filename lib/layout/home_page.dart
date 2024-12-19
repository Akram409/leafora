import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:leafora/components/pages/chats/screen/chat_layout.dart';
import 'package:leafora/components/pages/diagnose/diagnose_page.dart';
import 'package:leafora/components/pages/home/home_pages.dart';
import 'package:leafora/components/pages/my_account/my_account.dart';
import 'package:leafora/components/pages/my_plants/plants/my_plants_page.dart';
import 'package:leafora/components/shared/utils/screen_size.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';
import 'package:leafora/firebase_database_dir/service/chat_message_service.dart';
import 'package:leafora/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

  final ChaMessageService chatService = ChaMessageService();
   UserModel? currentUser;
  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  int currentIndex = 0;

// Navigation items for the bottom bar
  List<Widget> get items {
    return [
      Icon(Icons.home_outlined, size: 30, color: Colors.white),
      Icon(FontAwesomeIcons.userDoctor, size: 30, color: Colors.white),
      Icon(FontAwesomeIcons.plantWilt, size: 30, color: Colors.white),
      if (currentUser?.role == "expert") Icon(FontAwesomeIcons.message, size: 30, color: Colors.white),
      Icon(Icons.person, size: 30, color: Colors.white),
    ];
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    chatService.updateActiveStatus(true);
  }
  @override
  void dispose()
  {
    chatService.updateActiveStatus(false);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    if (state == AppLifecycleState.resumed) {
      print("resumed");
      chatService.updateActiveStatus(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      print(state.toString());
      chatService.updateActiveStatus(false);
    }
  }

  // Getter for dynamically generating pages
  List<Widget> get pages {
    return [
      HomePages(),
      DiagnosePage(),
      MyPlantsPage(),
      if (currentUser?.role == "expert") ChatLayout(),
      MyAccount(),
    ];
  }

  // Getter for dynamic titles matching navigation items
  List<String> get titles {
    return [
      'Home',
      'Diagnose',
      'Plants',
      if (currentUser?.role == "expert") 'Chats',
      'Profile',
    ];
  }

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
          color: Colors.green,
          buttonBackgroundColor: Colors.green,
          index: currentIndex,
          height: 75,
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


