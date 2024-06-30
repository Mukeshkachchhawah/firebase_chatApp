import 'package:chat_application/firebase_provider/firebase_provider.dart';
import 'package:chat_application/modal/message_modal.dart';
import 'package:chat_application/screens/chat_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Chat"),
        ),
        body: FutureBuilder(
          future: FirebaseProvider.getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

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
                                      : lastMsgModel!.message,
                                  style: const TextStyle(),
                                ),
                                trailing: Column(
                                  children: [
                                    // Text('${DateTime.now()}'),
                                    messages.isNotEmpty
                                        ? Text(lastMsgModel!.sent)
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
        ));
  }

  Widget showReadStatus(MessageModel lastMsg, String chatUserId) {
    if (lastMsg.fromId == FirebaseProvider.currUserId) {
      return Icon(
        Icons.done_all,
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
}