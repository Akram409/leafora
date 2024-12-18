import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leafora/components/pages/chats/widget/chat_user_card.dart';
import 'package:leafora/components/pages/chats/widget/dialoge.dart';
import 'package:leafora/components/pages/chats/widget/profile_image.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';
import 'package:leafora/firebase_database_dir/service/chat_message_service.dart';
import 'package:leafora/services/auth_service.dart';
import 'package:leafora/services/lifecycle_event_handler.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

//home screen -- where all available contacts are shown
class ChatLayout extends StatefulWidget {
  const ChatLayout({super.key});

  @override
  State<ChatLayout> createState() => _ChatLayoutState();
}

class _ChatLayoutState extends State<ChatLayout> {
  final AuthService _authService = AuthService();
  final ChaMessageService chatService = ChaMessageService();

  UserModel? _currentUser;

  // for storing all users
  List<UserModel> _list = [];

  // for storing searched items
  final List<UserModel> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Load current user
    _loadCurrentUser();
  }

  // Load user data from Firebase or your service
  Future<void> _loadCurrentUser() async {
    try {
      UserModel? user = await _authService.getCurrentUserData();
      setState(() {
        _currentUser = user;
      });
      // Print user details after loading
      if (user != null) {
        // print("Current User: ${user.toJson()}");
      } else {
        print("No user data available.");
      }
    } catch (e) {
      print("Error loading current user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(
        // TODO: check here
        // onWillPop: () {
        //   if (_isSearching) {
        //     setState(() {
        //       _isSearching = !_isSearching;
        //     });
        //     return Future.value(false);
        //   } else {
        //     return Future.value(true);
        //   }
        // },

        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        canPop: false,
        onPopInvoked: (_) {
          if (_isSearching) {
            setState(() => _isSearching = !_isSearching);
            return;
          }

          // some delay before pop
          Future.delayed(
              const Duration(milliseconds: 300), SystemNavigator.pop);
        },

        //
        child: Scaffold(
          //app bar
          appBar: AppBar(
            //view profile
            // TODO: check here
            leading: IconButton(
              tooltip: 'View Profile',
              onPressed: () {
                // TODO: check here
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => ProfileScreen(user: APIs.me)));
              },
              icon: const ProfileImage(size: 32),
            ),

            //title
            title: _isSearching
                ? TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Name, Email, ...'),
              autofocus: true,
              style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
              //when search text changes then updated search list
              onChanged: (val) {
                //search logic
                _searchList.clear();

                val = val.toLowerCase();

                for (var i in _list) {
                  if (i.userName!.toLowerCase().contains(val) ||
                      i.userEmail!.toLowerCase().contains(val)) {
                    _searchList.add(i);
                  }
                }
                setState(() => _searchList);
              },
            )
                : const Text('We Chat'),

            actions: [
              //search user button
              IconButton(
                  tooltip: 'Search',
                  onPressed: () => setState(() => _isSearching = !_isSearching),
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : CupertinoIcons.search)),

              //add new user
              IconButton(
                  tooltip: 'Add User',
                  padding: const EdgeInsets.only(right: 8),
                  onPressed: _addChatUserDialog,
                  icon: const Icon(CupertinoIcons.person_add, size: 25))
            ],
          ),

          //floating button to add new user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: (){},
                // TODO: check here
                // onPressed: () {
                //   Navigator.push(context,
                //       MaterialPageRoute(builder: (_) => const AiScreen()));
                // },
                child: Lottie.asset('assets/images/upload-2.json', width: 40)),
          ),

          //body
          body: StreamBuilder(
            // here
            stream: chatService.getMyUsersId(),

            //get id of only known users
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
              //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

              //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: chatService.getAllUsers(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                    //get only those user, who's ids are provided
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                      //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return const Center(
                        //     child: CircularProgressIndicator());

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:

                          final data = snapshot.data?.docs;
                          _list = data
                              ?.map((e) => UserModel.fromJson(e.data()))
                              .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _isSearching
                                    ? _searchList.length
                                    : _list.length,
                                padding: EdgeInsets.only(top: screenHeight * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ChatUserCard(
                                      user: _isSearching
                                          ? _searchList[index]
                                          : _list[index]);
                                });
                          } else {
                            return const Center(
                              child: Text('No Connections Found!',
                                  style: TextStyle(fontSize: 20)),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  // for adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: const EdgeInsets.only(
              left: 24, right: 24, top: 20, bottom: 10),

          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),

          //title
          title: const Row(
            children: [
              Icon(
                Icons.person_add,
                color: Colors.blue,
                size: 28,
              ),
              Text('  Add User')
            ],
          ),

          //content
          content: TextFormField(
            maxLines: null,
            onChanged: (value) => email = value,
            decoration: const InputDecoration(
                hintText: 'Email Id',
                prefixIcon: Icon(Icons.email, color: Colors.blue),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
          ),

          //actions
          actions: [
            //cancel button
            MaterialButton(
                onPressed: () {
                  //hide alert dialog
                  Navigator.pop(context);
                },
                child: const Text('Cancel',
                    style: TextStyle(color: Colors.blue, fontSize: 16))),

            //add button
            MaterialButton(
                onPressed: () async {
                  //hide alert dialog
                  Navigator.pop(context);
                  if (email.trim().isNotEmpty) {
                    print("email is this: ${email}");
                    await chatService.addChatUser(email).then((value) {
                      print(value);
                      if (!value) {
                        Dialogs.showSnackbar(
                            context, 'User does not Exists!');
                      }
                    });
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ))
          ],
        ));
  }
}