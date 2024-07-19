import 'package:chat_application/screens/chat_screen/chat_bubbes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_application/firebase_provider/firebase_provider.dart';
import 'package:chat_application/modal/message_modal.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatView extends StatefulWidget {
  final String userName;
  String toId;

  ChatView({super.key, required this.userName, this.toId = ""});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController messageController = TextEditingController();
  bool hasContent = false;
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatStream;
  MessageModel? selectedMessage;

  @override
  void initState() {
    super.initState();
    getChatStream();
  }

  void getChatStream() async {
    chatStream = await FirebaseProvider.getAllMessage(widget.toId);
    setState(() {});
  }

  void _sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String imageUrl = await FirebaseProvider.uploadImage(imageFile);

      FirebaseProvider.sendMsg(imageUrl, widget.toId, imageUrl: imageUrl);

      messageController.clear();
    }
  }

  void _captureFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String imageUrl = await FirebaseProvider.uploadImage(imageFile);

      FirebaseProvider.sendMsg(imageUrl, widget.toId, imageUrl: imageUrl);

      messageController.clear();
    }
  }

  void _deleteSelectedMessage() async {
    if (selectedMessage != null) {
      String msgId = selectedMessage!.mId;
      setState(() {
        selectedMessage = null;
      });

      await FirebaseProvider.deleteMsg(msgId, widget.toId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message deleted successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        actions: [
          if (selectedMessage != null)
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: _deleteSelectedMessage,
            ),
        ],
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
                  var allMessages = snapshot.data!.docs;
                  return allMessages.isNotEmpty
                      ? ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var currMsg = MessageModel.fromJson(
                                allMessages[index].data());
                            return ChatBubblesWidget(
                              msg: currMsg,
                              onDelete: () {
                                setState(() {
                                  selectedMessage = currMsg;
                                });
                              },
                            );
                          },
                        )
                      : const Center(child: Text("No Chat"));
                }
                return Container();
              },
            ),
          ),
          _buildInputField(),
/*           _isEmojiVisible ? _buildEmojiPicker() : Container(),
 */
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
              trailing: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _sendImage,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: _captureFromCamera,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          hasContent
              ? InkWell(
                  onTap: () {
                    FirebaseProvider.sendMsg(
                        messageController.text.toString(), widget.toId);
                    messageController.clear();
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
                  child: InkWell(
                    child: Icon(
                      Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
