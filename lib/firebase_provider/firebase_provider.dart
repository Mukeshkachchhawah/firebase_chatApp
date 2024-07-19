import 'dart:io';
import 'package:chat_application/modal/message_modal.dart';
import 'package:chat_application/modal/user_data_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseProvider {
  static final FirebaseAuth mAuth = FirebaseAuth.instance;
  static final FirebaseFirestore mFirestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static const String USER_COLLECTION = "users";
  static const String CHATROOM_COLLECTION = "chatroom";
  static const String STATUS_COLLECTION = "status"; // New collection for user statuses

  static String currUserId = mAuth.currentUser!.uid;

  static Future<void> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required Widget loginScreen,
      required BuildContext context}) async {
    try {
      await mAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint(mAuth.currentUser!.email);
      debugPrint("uid: ${mAuth.currentUser!.uid}");
      _setOnlineStatus(true); // Set user online status to true
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => loginScreen,
          ));
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e is FirebaseAuthException && e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      } else {
        print(e);
      }
    }
  }

  static Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String firstNameValue,
    required String lastNameValue,
    required String phoneValue,
  }) async {
    try {
      await mAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      mFirestore.collection(USER_COLLECTION).doc(mAuth.currentUser!.uid).set(
          UserDataModal(
                  userId: mAuth.currentUser!.uid,
                  uFirstName: firstNameValue,
                  uLastName: lastNameValue,
                  uEmail: email,
                  uPhoneNumber: phoneValue)
              .toJson());
      _setOnlineStatus(true); // Set user online status to true
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await mAuth.signInWithCredential(credential);
      currUserId = userCredential.user!.uid; // Update currUserId
      _setOnlineStatus(true); // Set user online status to true
      return userCredential.user;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  static Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await mAuth.signOut();
    _setOnlineStatus(false); // Set user online status to false
  }

  Future<void> signOut() async {
    await mAuth.signOut();
    _setOnlineStatus(false); // Set user online status to false
  }

  static Future<List<UserDataModal>> getAllUsers() async {
    List<UserDataModal> arrUsers = [];

    var arrUserData = await mFirestore.collection(USER_COLLECTION).get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> eachUser
        in arrUserData.docs) {
      var dataModel = UserDataModal.fromJson(eachUser.data());
      if (dataModel.userId != mAuth.currentUser!.uid) {
        arrUsers.add(dataModel);
      }
    }

    return arrUsers;
  }

  static signOutUser() {
    mAuth.signOut();
    _setOnlineStatus(false); // Set user online status to false
  }

  static String getChatID(String fromId, String toId) {
    if (fromId.hashCode <= toId.hashCode) {
      return "${fromId}_$toId";
    } else {
      return "${toId}_$fromId";
    }
  }

  static Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('images/$fileName.jpg');
      await ref.putFile(imageFile);
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return ''; // Return empty string or handle error as needed
    }
  }

  static void sendMsg(String msg, String toId, {String? imageUrl}) async {
    var chatId = getChatID(currUserId, toId);
    debugPrint(currUserId);
    debugPrint("Chat id : $chatId");

    var sentTime = DateTime.now().millisecondsSinceEpoch;

    String msgType = imageUrl != null ? 'image' : 'text';
    String messageContent = imageUrl ?? msg;

    var newMessage = MessageModel(
        fromId: currUserId,
        mId: sentTime.toString(),
        message: messageContent,
        msgType: msgType,
        sent: sentTime.toString(),
        toId: toId,
        status: 'sent'); // Add status field

    mFirestore
        .collection(CHATROOM_COLLECTION)
        .doc(chatId)
        .collection("messages")
        .doc(sentTime.toString())
        .set(newMessage.toJson());

    // Check if the recipient is online
    bool isOnline = await _isUserOnline(toId);
    if (isOnline) {
      _updateMessageStatus(chatId, sentTime.toString(), 'delivered');
    }
  }

  static Future<void> deleteMsg(String msgId, String chatId) async {
    try {
      await FirebaseFirestore.instance
          .collection(CHATROOM_COLLECTION)
          .doc(chatId)
          .collection('messages')
          .doc(msgId)
          .delete();
    } catch (e) {
      print('Error deleting message: $e');
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage(
      String toId) {
    var chatId = getChatID(currUserId, toId);
    print("Chat id : $chatId");

    return mFirestore
        .collection(CHATROOM_COLLECTION)
        .doc(chatId)
        .collection("messages")
        .snapshots();
  }

  static void updateReadTime(String mId, String fromId) {
    var chatId = getChatID(currUserId, fromId);
    var readTime = DateTime.now().millisecondsSinceEpoch;

    mFirestore
        .collection(CHATROOM_COLLECTION)
        .doc(chatId)
        .collection("messages")
        .doc(mId)
        .update({"read": readTime.toString(), "status": "read"});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatLastMsg(
      String chatUserId) {
    var chatId = getChatID(currUserId, chatUserId);

    return mFirestore
        .collection(CHATROOM_COLLECTION)
        .doc(chatId)
        .collection("messages")
        .orderBy("sent", descending: true)
        .limit(1)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUnReadCount(
      String chatUserId) {
    var chatId = getChatID(currUserId, chatUserId);

    return mFirestore
        .collection(CHATROOM_COLLECTION)
        .doc(chatId)
        .collection("messages")
        .where("fromId", isEqualTo: chatUserId)
        .where("read", isEqualTo: "")
        .snapshots();
  }

  // Set the online status of the current user
  static void _setOnlineStatus(bool isOnline) {
    mFirestore
        .collection(STATUS_COLLECTION)
        .doc(currUserId)
        .set({'online': isOnline});
  }

  // Check if a user is online
  static Future<bool> _isUserOnline(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await mFirestore.collection(STATUS_COLLECTION).doc(userId).get();
    return doc.data()?['online'] ?? false;
  }

  // Update the message status
  static Future<void> _updateMessageStatus(
      String chatId, String msgId, String status) async {
    await mFirestore
        .collection(CHATROOM_COLLECTION)
        .doc(chatId)
        .collection("messages")
        .doc(msgId)
        .update({"status": status});
  }
}
