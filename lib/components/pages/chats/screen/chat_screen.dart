import 'dart:developer';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafora/components/pages/chats/widget/message_card.dart';
import 'package:leafora/components/pages/chats/widget/profile_image.dart';
import 'package:leafora/components/shared/utils/date_util.dart';
import 'package:leafora/firebase_database_dir/models/chat_message.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';
import 'package:leafora/firebase_database_dir/service/chat_message_service.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChaMessageService chatService = ChaMessageService();
  //for storing all messages
  List<ChatMessage> _list = [];

  //for handling message text changes
  final _textController = TextEditingController();

  //showEmoji -- for storing value of showing or hiding emoji
  //isUploading -- for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(
        // onWillPop: () {
        //   if (_showEmoji) {
        //     setState(() => _showEmoji = !_showEmoji);
        //     return Future.value(false);
        //   } else {
        //     return Future.value(true);
        //   }
        // },

        //if emojis are shown & back button is pressed then hide emojis
        //or else simple close current screen on back button click
        canPop: false,

        onPopInvoked: (_) {
          if (_showEmoji) {
            setState(() => _showEmoji = !_showEmoji);
            return;
          }

          // some delay before pop
          Future.delayed(const Duration(milliseconds: 300), () {
            try {
              if (Navigator.canPop(context)) Navigator.pop(context);
            } catch (e) {
              log('ErrorPop: $e');
            }
          });
        },

        //
        child: Scaffold(
          //app bar
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
            backgroundColor: Colors.white,
          ),

          backgroundColor: const Color.fromARGB(255, 234, 248, 255),

          //body
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: chatService.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                      //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                      //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                              ?.map((e) => ChatMessage.fromJson(e.data()))
                              .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: screenHeight * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(message: _list[index]);
                                });
                          } else {
                            return const Center(
                              child: Text('Say Hii! 👋',
                                  style: TextStyle(fontSize: 20)),
                            );
                          }
                      }
                    },
                  ),
                ),

                //progress indicator for showing uploading
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(strokeWidth: 2))),

                //chat input filed
                _chatInput(),

                //show emojis on keyboard emoji button click & vice versa
                if (_showEmoji)
                  SizedBox(
                    height: screenHeight * .35,
                    child: EmojiPicker(
                      key: Key("dfsd"),
                      textEditingController: _textController,
                      config: const Config(),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // app bar widget
  Widget _appBar() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: InkWell(
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (_) => ViewProfileScreen(user: widget.user)));
          },
          child: StreamBuilder(
              stream: chatService.getUserInfo(widget.user.userId!),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => UserModel.fromJson(e.data())).toList() ??
                        [];

                return Row(
                  children: [
                    //back button
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.green)),

                    //user profile picture
                    ProfileImage(
                      size:
                      screenWidth * .09,
                      url: widget.user.userImage != null
                          ? widget.user.userImage![
                      'url']
                          : "/assets/images/profile.png",
                    ),

                    //for adding some space
                    const SizedBox(width: 10),

                    //user name & last seen time
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //user name
                        Text(list.isNotEmpty ? list[0].userName! : widget.user.userName!,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w700)),

                        //for adding some space
                        const SizedBox(height: 2),

                        //last seen time of user
                        Text(
                          list.isNotEmpty
                              ? list[0].isOnline == true
                              ? 'Online'
                              : DateUtil.getLastActiveTime(
                              context: context,
                              lastActive: list[0].lastActive!)
                              : DateUtil.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive!),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    )
                  ],
                );
              })),
    );
  }

  // bottom chat input field
  Widget _chatInput() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: screenHeight * .01, horizontal:screenWidth * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.green, size: 25)),

                  Expanded(
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onTap: () {
                          if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                        },
                        decoration: const InputDecoration(
                            hintText: 'Type Something...',
                            hintStyle: TextStyle(color: Colors.green),
                            border: InputBorder.none),
                      )),

                  //pick image from gallery button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Picking multiple images
                        final List<XFile> images =
                        await picker.pickMultiImage(imageQuality: 70);

                        // uploading & sending image one by one
                        for (var i in images) {
                          log('Image Path: ${i.path}');
                          setState(() => _isUploading = true);
                          // TODO: check here enable the sendChatImage
                          // await chatService.sendChatImage(widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.image,
                          color: Colors.green, size: 26)),

                  //take image from camera button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      // Pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      // TODO: check here enable hte sendChatImage
                      // if (image != null) {
                      //   log('Image Path: ${image.path}');
                      //   setState(() => _isUploading = true);
                      //
                      //   await chatService.sendChatImage(
                      //       widget.user, File(image.path));
                      //   setState(() => _isUploading = false);
                      // }
                    },
                    icon: const Icon(Icons.camera_alt_rounded, size: 26),
                    color: Colors.green,  // Corrected to use a Color object
                  ),

                  //adding some space
                  SizedBox(width: screenWidth * .02),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  chatService.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  //simply send message
                  chatService.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
            const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send_outlined, color: Colors.white, size: 25),
          )
        ],
      ),
    );
  }
}