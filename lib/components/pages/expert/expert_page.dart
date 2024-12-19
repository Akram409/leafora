import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:leafora/components/pages/chats/widget/dialoge/profile_dialoge.dart';
import 'package:leafora/components/shared/utils/screen_size.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';
import 'package:leafora/firebase_database_dir/service/chat_message_service.dart';

class ExpertPage extends StatefulWidget {
  const ExpertPage({super.key});

  @override
  State<ExpertPage> createState() => _ExpertPageState();
}

class _ExpertPageState extends State<ExpertPage> {
  final ChaMessageService chatService = ChaMessageService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List list = [
    "Flutter",
    "React",
    "Ionic",
    "Xamarin",
  ];

  Stream<List<UserModel>> getExpertsStream() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'expert')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  void _addChatUserDialog(String userEmail) async {
    String? email = userEmail;
    print(email);
    // Show the info dialog first
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'User Confirmation',
      desc: 'Are you sure to add this user to the chat?',
      btnOkText: 'Yes',
      btnCancelText: 'No',
      btnOkOnPress: () {
        // If the user confirms, proceed with adding the chat user
        chatService.addChatUser(email!).then((value) {
          if (!value) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.scale,
              title: 'Error',
              desc: 'User does not exist!',
              btnOkOnPress: () {},
            ).show();
          } else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.scale,
              title: 'Success',
              desc: 'You have successfully added the chat user.',
              btnOkOnPress: () {
                // Optionally, you can navigate to another screen or perform another action here.
              },
            ).show();
          }
        });
      },
      btnCancelOnPress: () {
        // Cancel action
        print('User cancelled the action.');
      },
    ).show();
  }



  @override
  Widget build(BuildContext context) {
    var screenWidth = ScreenSize.width(context);
    var gapHeight1 = 20.0;

    return Scaffold(
      appBar: CustomAppBar3(title: "Experts"),
      body: Column(
        children: [
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

          // Experts List
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: getExpertsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No experts found.'));
                }

                final experts = snapshot.data!;
                return ListView.builder(
                  itemCount: experts.length,
                  itemBuilder: (context, index) {
                    final expert = experts[index];
                    return Card(
                      elevation: 6,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // Profile Picture with Border
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => ProfileDialog(user: expert));
                              },
                              child: Container(
                                width: 64, // Diameter of the avatar including the border
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blue, // Border color
                                    width: 4.0, // Border thickness
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 30, // Adjust radius for internal image size
                                  backgroundImage: NetworkImage(
                                    expert.userImage?['url'] ??
                                        '/assets/images/profile.png', // Placeholder image
                                  ),
                                  backgroundColor: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Text Information
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name
                                  Text(
                                    expert.userName ?? 'Unknown User',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Email
                                  Text(
                                    expert.userEmail ?? 'No email provided',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Status and Action Icons
                            Column(
                              children: [
                                Icon(
                                  expert.isOnline == 'true'
                                      ? Icons.circle
                                      : Icons.circle_outlined,
                                  color: expert.isOnline == 'true' ? Colors.green : Colors.red,
                                  size: 14,
                                ),
                                const SizedBox(height: 8),
                                IconButton(
                                  onPressed: () {
                                    onPressed: _addChatUserDialog(expert!.userEmail!);
                                  },
                                  icon: Icon(
                                    Icons.message,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
