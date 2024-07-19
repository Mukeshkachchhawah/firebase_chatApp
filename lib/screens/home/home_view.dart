import 'package:chat_application/deshbord/splash_view.dart';
import 'package:chat_application/deshbord/user_account/login_view.dart';
import 'package:chat_application/firebase_provider/firebase_provider.dart';
import 'package:chat_application/modal/message_modal.dart';
import 'package:chat_application/screens/chat_screen/chat_view.dart';
import 'package:chat_application/screens/user_contect/context_user_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 15.0,
        title: const Text("My Chat"),
        actions: [
          IconButton(
              onPressed: () async {
                await logoutUser(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder(
        future: FirebaseProvider.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          /*    if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("No users found"),
            );
          } */
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var currUser = snapshot.data![index];

                /// ChatListTile
                return StreamBuilder(
                    stream: FirebaseProvider.getChatLastMsg(currUser.userId!),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        var messages = snapshot.data!.docs;
                        MessageModel? lastMsgModel;
                        if (messages.isNotEmpty) {
                          lastMsgModel =
                              MessageModel.fromJson(messages[0].data());
                        }

                        return InkWell(
                          onTap: () {
                            if (MediaQuery.of(context).orientation ==
                                Orientation.portrait) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatView(
                                      userName: currUser.uFirstName,
                                      toId: currUser.userId!,
                                    ),
                                  ));
                            }
                          },
                          child: Card(
                            color: Colors.white,
                            child: ListTile(
                              leading: CircleAvatar(
                                foregroundImage: NetworkImage(currUser
                                            .uProfilePic !=
                                        ""
                                    ? 'https://avatars.githubusercontent.com/u/76419786?v=4'
                                    : "https://cdn3.iconfinder.com/data/icons/avatars-round-flat/33/avat-01-512.png"),
                              ),
                              title: Text(
                                currUser.uFirstName,
                                style: const TextStyle(),
                              ),
                              subtitle: Text(
                                messages.isEmpty
                                    ? currUser.uLastName
                                    : (lastMsgModel!.msgType == 'image'
                                        ? 'Image'
                                        : lastMsgModel.message),
                                style: const TextStyle(),
                              ),
                              trailing: Column(
                                children: [
                                  // Text('${DateTime.now()}'),
                                  messages.isNotEmpty
                                      ? Text(TimeOfDay.fromDateTime(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  int.parse(
                                                      lastMsgModel!.sent)))
                                          .format(context))
                                      : const SizedBox(
                                          width: 0,
                                          height: 0,
                                        ),
                                  messages.isNotEmpty
                                      ? showReadStatus(
                                          lastMsgModel!, currUser.userId!)
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactUserView(),
              ));
        },
        child: const Icon(Icons.call),
      ),
    );
  }

  Widget showReadStatus(MessageModel lastMsg, String chatUserId) {
    if (lastMsg.fromId == FirebaseProvider.currUserId) {
      return Icon(
        lastMsg.status == 'read' ? Icons.done_all : Icons.done,
        size: 20,
        color: lastMsg.read != "" ? Colors.blue : Colors.grey,
      );
    } else {
      return StreamBuilder(
        stream: FirebaseProvider.getUnReadCount(chatUserId),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            var messages = snapshot.data!.docs;
            if (messages.isEmpty) {
              return const SizedBox();
            } else {
              return Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                    color: Colors.green, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    '${messages.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          }
          return const SizedBox();
        },
      );
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      var sp = await SharedPreferences.getInstance();
      sp.setBool(SplashViewState.LOGIN_KEY, false);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error logging out: $e");
    }
  }
}
