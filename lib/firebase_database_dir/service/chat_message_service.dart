

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:leafora/firebase_database_dir/models/chat_message.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';
import 'package:leafora/firebase_database_dir/service/user_service.dart';
import 'package:leafora/services/notification_service.dart';

class ChaMessageService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService = NotificationService.instance;
  late UserModel? _currentUser;

  ChaMessageService() {
    _initializeCurrentUser();
  }

  Future<void> _initializeCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      _currentUser = await _userService.getUser(user.uid);
    } else {
      throw Exception("No user is currently logged in.");
    }
  }


// chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // for getting specific user info
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(String userId) {
    return _firestore
        .collection('users')
        .where('userId', isEqualTo: userId)
        .snapshots();

  }


  // Update user status (online/offline) with last active time
  Future<void> updateActiveStatus(bool isOnline) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update Firestore document
        await _firestore.collection('users').doc(user.uid).update({
          'isOnline': isOnline.toString(), // Ensure it's a string
          'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
        });
      } else {
        log(
          'No user is currently logged in',
          name: 'ChaMessageService',
        );
      }
    } catch (e) {
      // Log any errors that occur during the update
      log(
        'Error updating active status',
        name: 'ChaMessageService',
        error: e,
      );
    }
  }

  // New Function: Get IDs of known users from Firestore
  Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
      final user = _auth.currentUser;

    if (user == null) {
      throw Exception("No user is currently logged in.");
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('my_chat_users')
        .snapshots();
  }


  // Fetch all users from Firestore based on a list of user IDs
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    return FirebaseFirestore.instance
        .collection('users')
        .where(
      'userId',
      whereIn: userIds.isEmpty ? [''] : userIds,
    ) // Empty list workaround
        .snapshots();
  }


  Future<bool> addChatUser(String userEmail) async {
    try {
      // Query Firestore for a user document with the matching userEmail
      final data = await _firestore
          .collection('users')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      // Check if a user document was found and is not the current user
      if (data.docs.isNotEmpty && data.docs.first.id != _auth.currentUser?.uid) {
        // Log the user details
        print('User exists: ${data.docs.first.data()}');

        // Add the user to the "my_chat_users" subcollection of the current user
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('my_chat_users')
            .doc(data.docs.first.id)
            .set({});

        print('Chat user added successfully.');
        return true; // Successfully added the user
      } else {
        print('User does not exist or trying to add self.');
        return false; // User not found or is the current user
      }
    } catch (e) {
      print('Error adding chat user: $e');
      return false; // Handle errors gracefully
    }
  }

// useful for getting conversation id
   String getConversationID(String id) =>
      _auth.currentUser!.uid.hashCode <= id.hashCode
          ? '${_auth.currentUser!.uid}_$id'
          : '${id}_${_auth.currentUser!.uid}';

  // static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
  //     ? '${user.uid}_$id'
  //     : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
   Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel user) {
    return _firestore
        .collection('chats/${getConversationID(user.userId!)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }
  // for adding an user to my user when first message is send
  Future<void> sendFirstMessage(
      UserModel chatUser, String msg, Type type) async {
    if (_currentUser == null) {
      log('Error: Current user is null');
      return;
    }

    await _firestore
        .collection('users')
        .doc(chatUser.userId)
        .collection('my_chat_users')
        .doc(_currentUser?.userId)
        .set({})
        .then((value) => sendMessage(chatUser, msg, type))
        .catchError((e) {
      print('Error sending first message: $e');
    });
  }
  // for sending message
   Future<void> sendMessage(
      UserModel chatUser, String msg, Type type) async {
     if (_currentUser == null) {
       log('Error: Current user is null');
       return;
     }

    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final ChatMessage message = ChatMessage(
        toId: chatUser.userId!,
        msg: msg,
        read: '',
        type: type,
        fromId: _currentUser!.userId!,
        sent: time);

    final ref = _firestore
        .collection('chats/${getConversationID(chatUser.userId!)}/messages/');
     try {
       final ref = _firestore
           .collection('chats/${getConversationID(chatUser.userId!)}/messages/');
       await ref.doc(time).set(message.toJson());
       log('Message sent successfully');
     } catch (e) {
       log('Error sending message: $e');
     }

     // Sending push notification to the specific user
     final String? userToken = await _userService.getUserToken(chatUser.userId);
     try {
       // Get the user token
       if (userToken != null) {
         await _notificationService.sendPushNotification(
           userToken,
           {
             "title": "New Message from ${_currentUser!.userName}",
             "body": type == Type.text ? msg : 'Sent you an image',
             "data": {
               "conversationId": getConversationID(chatUser.userId!),
               "fromId": _currentUser!.userId!,
             },
           },
         );
         log('Push notification sent successfully to token: $userToken');
       } else {
         log('No token found for user ${chatUser.userId}');
       }
     } catch (e) {
       log('Error while sending push notification: $e');
       // Optionally handle invalid tokens here
       if (e.toString().contains("Invalid registration token")) {
         await _userService.removeInvalidToken(userToken!);
         log('Removed invalid token: $userToken');
       }
     }
  }

  // Update read status of a message
   Future<void> updateMessageReadStatus(ChatMessage message) async {
    final ref = _firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent);
    await ref.update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // Get only the last message of a specific chat
   Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(UserModel user) {
    return _firestore
        .collection('chats/${getConversationID(user.userId!)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // TODO: check here: sendChat Image enable here
  //send chat image
   Future<void> sendChatImage(UserModel chatUser, Map<String, String>? file) async {
    //getting image file extension
    String imageUrl = file!['url']!;

    //updating image in firestore database
    await sendMessage(chatUser, imageUrl, Type.image);
  }


  // Delete a message
   Future<void> deleteMessage(ChatMessage message) async {
    final ref = _firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent);
    await ref.delete();

    // TODO: remove image from cloudinary
    // if (message.type == Type.image) {
    //   await storage.refFromURL(message.msg).delete();
    // }
  }

  // Update a message
   Future<void> updateMessage(ChatMessage message, String updatedMsg) async {
    final ref = _firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent);
    await ref.update({'msg': updatedMsg});
  }
}