import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ChatView extends StatefulWidget {
  final String userName;

  const ChatView({super.key, required this.userName});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  bool _isEmojiVisible = false;

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(_messageController.text);
        _messageController.clear();
        _isEmojiVisible = false; // Hide emoji picker after sending a message
      });
    }
  }

  void _toggleEmojiPicker() {
    setState(() {
      _isEmojiVisible = !_isEmojiVisible;
    });
  }

  void _onEmojiSelected(Emoji emoji) {
    _messageController.text += emoji.emoji;
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
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 80),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _messages[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildInputField(),
          _isEmojiVisible ? _buildEmojiPicker() : Container(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Row(
      children: [
        Expanded(
            child: SearchBar(
          controller: _messageController,
          hintText: 'Enter your message...',
          leading: IconButton(
            icon: Icon(Icons.emoji_emotions),
            onPressed: _toggleEmojiPicker,
          ),
          trailing: [
            IconButton(
              icon: Icon(Icons.attach_file),
              onPressed: () {
                // Handle media selection (e.g., file picker)
              },
            ),
            IconButton(
              icon: Icon(Icons.camera_alt_outlined),
              onPressed: () {
                // Handle media selection (e.g., file picker)
              },
            )
          ],
        )),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: _sendMessage,
        ),
      ],
    );
  }

  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          _onEmojiSelected(emoji);
        },
        config: Config(),
      ),
    );
  }
}
