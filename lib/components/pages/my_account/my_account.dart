import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:leafora/components/authentication/login_screen.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';
import 'package:leafora/firebase_database_dir/service/user_service.dart';
import 'package:leafora/services/auth_service.dart';
import 'package:badges/badges.dart' as badges;

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  // Load user data from Firebase or your service
  void _loadCurrentUser() {
    _userService.getUserData().listen((user) {
      setState(() {
        _currentUser = user;
      });
      // Print user details after loading
      if (user != null) {
        print("Current User: ${user.toJson()}");
      } else {
        print("No user data available.");
      }
    });
  }

  // Logout function
  Future<void> _logout() async {
    try {
      await _authService.signOut();
      // Navigate to login screen after logging out
      Get.offAll(LoginScreen());
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isPlan = _currentUser?.plan == 'Pro';
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Image
                  GFAvatar(
                    backgroundImage: _currentUser?.userImage != null
                        ? NetworkImage(_currentUser!.userImage!['url'] ??
                            "https://via.placeholder.com/150")
                        : const NetworkImage("https://via.placeholder.com/150"),
                    shape: GFAvatarShape.circle,
                    size: 50,
                  ),
                  const SizedBox(width: 16),
                  // Name and Email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _currentUser?.userName ?? "John Doe",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.06,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isPlan ? Colors.green : Colors.grey[700],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isPlan ? "Pro" : "Basic",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentUser?.userEmail ?? "Unknown Email",
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_outlined,
                    color: Colors.green,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Upgrade Plan Section
              if(!isPlan) Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        FontAwesomeIcons.crown,
                        size: 24,
                        color: Colors.green,
                      ),
                    ),
                    // Text content
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Get.toNamed("/subscription",arguments: _currentUser);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Upgrade Plan to Unlock More!",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.037,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Enjoy All the benefits and explore more possibilities",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.02,
                                  color: Colors.white.withOpacity(0.7)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_outlined,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section List
              // buildSection(
              //     icon: Icons.person_outline,
              //     title: "My Account",
              //     screenWidth: screenWidth,
              //     path: ""),
              buildSection(
                  icon: Icons.receipt_long_outlined,
                  title: "Billing & Subscription",
                  screenWidth: screenWidth,
                  path: "subscription"),
              buildSection(
                  icon: Icons.payment_outlined,
                  title: "Payment Methods",
                  screenWidth: screenWidth,
                  path: "paymentMethod"),
              // buildSection(
              //     icon: Icons.info_outline,
              //     title: "About Us",
              //     screenWidth: screenWidth,
              //     path: ""),

              // Logout Button
              ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                  size: screenWidth * 0.07,
                  color: Colors.red,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                      color: Colors.red),
                ),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build List Section
  Widget buildSection(
      {required IconData icon,
      required String title,
      required double screenWidth,
      required String path}) {
    return ListTile(
      leading: Icon(
        icon,
        size: screenWidth * 0.07,
        color: Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w600,
            color: Colors.black),
      ),
      trailing: const Icon(
        Icons.chevron_right_outlined,
        color: Colors.black54,
      ),
      onTap: () {
        if (path == "subscription") {
          Get.toNamed(path, arguments: _currentUser);
        } else {
          Get.toNamed(path);
        }
      },
    );
  }
}
