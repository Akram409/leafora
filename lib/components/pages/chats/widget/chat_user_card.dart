import 'package:flutter/material.dart';
import 'package:leafora/components/pages/chats/screen/chat_screen.dart';
import 'package:leafora/components/pages/chats/widget/dialoge/profile_dialoge.dart';
import 'package:leafora/components/pages/chats/widget/profile_image.dart';
import 'package:leafora/components/shared/utils/date_util.dart';
import 'package:leafora/firebase_database_dir/models/chat_message.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';

import '../../../../firebase_database_dir/service/chat_message_service.dart';
import '../../../../services/auth_service.dart';

//card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final UserModel user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  final AuthService _authService = AuthService();
  final ChaMessageService chatService = ChaMessageService();

  //last message info (if null --> no message)
  ChatMessage? _message;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * .04, vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          onTap: () {
            //for navigating to chat screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(user: widget.user)));
          },
          child: StreamBuilder(
            stream: chatService.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatMessage.fromJson(e.data())).toList() ??
                      [];
              if (list.isNotEmpty) _message = list[0];

              return ListTile(
                //user profile picture
                leading: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => ProfileDialog(user: widget.user));
                  },
                  child: ProfileImage(
                    size:
                        screenWidth * .12,
                    url: widget.user.userImage != null
                        ? widget.user.userImage![
                            'url']
                        : null,
                  ),
                ),

                //user name
                title: Text(widget.user.userName!,style: TextStyle(
                  fontSize: screenWidth*0.06
                ),),

                //last message
                subtitle: Text(
                    _message != null
                        ? _message!.type == Type.image
                            ? 'image'
                            : _message!.msg
                        : widget.user.about!,
                    maxLines: 1),

                //last message time
                trailing: _message == null
                    ? null //show nothing when no message is sent
                    : _message!.read.isEmpty &&
                            _message!.fromId != _authService.userId
                        ?
                        //show for unread message
                        const SizedBox(
                            width: 15,
                            height: 15,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 0, 230, 119),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          )
                        :
                        //message sent time
                        Text(
                            DateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: const TextStyle(color: Colors.black54),
                          ),
              );
            },
          )),
    );
  }
}
