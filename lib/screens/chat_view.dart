import 'package:chat_application/firebase_provider/firebase_provider.dart';
import 'package:chat_application/modal/message_modal.dart';
import 'package:chat_application/screens/chat_bubbes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

// ignore: must_be_immutable
class ChatView extends StatefulWidget {
  final String userName;
  String toId;

  ChatView({super.key, required this.userName, this.toId = ""});

  @override
  // ignore: library_private_types_in_public_api
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController messageController = TextEditingController();
  bool _isEmojiVisible = false;
  bool hasContent = false;
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatStream;

  @override
  void initState() {
    super.initState();
    getChatStream();
  }

  getChatStream() async {
    chatStream = await FirebaseProvider.getAllMessage(widget.toId);
    setState(() {});
  }

  void _toggleEmojiPicker() {
    setState(() {
      _isEmojiVisible = !_isEmojiVisible;
    });
  }

  void _onEmojiSelected(Emoji emoji) {
    messageController.text += emoji.emoji;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: chatStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                var allMassage = snapshot.data!.docs;
                return allMassage.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var currMsg =
                              MessageModel.fromJson(allMassage[index].data());
                          return ChatBubblesWidget(msg: currMsg);
                        },
                      )
                    : const Center(child: Text("No Chat"));
              }
              return Container();
            },
          )),
          _buildInputField(),
          _isEmojiVisible ? _buildEmojiPicker() : Container(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
              child: SearchBar(
            controller: messageController,
            hintText: 'Enter your message...',
            onChanged: (text) {
              setState(() {
                hasContent = text.isNotEmpty;
              });
            },
            leading: IconButton(
              icon: const Icon(Icons.emoji_emotions),
              onPressed: _toggleEmojiPicker,
            ),
            trailing: [
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: () {
                  // Handle media selection (e.g., file picker)
                },
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                onPressed: () {
                  // Handle media selection (e.g., file picker)
                },
              )
            ],
          )),
          hasContent
              ? InkWell(
                  onTap: () {
                    print("Click Send Massager");
                    FirebaseProvider.sendMsg(
                        messageController.text.toString(), widget.toId);
                    messageController.text = "";
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              : const CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: Icon(
                    Icons.mic,
                    color: Colors.white,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          _onEmojiSelected(emoji);
        },
        config: const Config(),
      ),
    );
  }
}
