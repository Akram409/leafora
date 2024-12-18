import 'package:flutter/material.dart';
import 'package:leafora/components/pages/chats/widget/profile_image.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';


class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      content: SizedBox(
          width: screenWidth * .6,
          height: screenHeight * .35,
          child: Stack(
            children: [
              //user profile picture
              Positioned(
                top: screenHeight * .075,
                left: screenWidth * .1,
                child: ProfileImage(size: screenWidth * .5, url: user.userImage![
                'url']),
              ),

              //user name
              Positioned(
                left: screenWidth * .04,
                top: screenHeight * .02,
                width: screenWidth * .55,
                child: Text(user.userName!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ),

              //info button
              Positioned(
                  right: 8,
                  top: 6,
                  child: MaterialButton(
                    onPressed: () {
                      //for hiding image dialog
                      // TODO: check here enable the view Profile screen
                      // Navigator.pop(context);
                      //
                      // //move to view profile screen
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => ViewProfileScreen(user: user)));
                    },
                    minWidth: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.info_outline,
                        color: Colors.blue, size: 30),
                  ))
            ],
          )),
    );
  }
}