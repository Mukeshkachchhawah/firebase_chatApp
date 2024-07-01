import 'package:chat_application/firebase_provider/firebase_provider.dart';
import 'package:chat_application/modal/message_modal.dart';
import 'package:chat_application/ui_helper.dart';
import 'package:flutter/material.dart';

class ChatBubblesWidget extends StatefulWidget {
  MessageModel msg;

  ChatBubblesWidget({
    required this.msg,
  });

  @override
  State<ChatBubblesWidget> createState() => _ChatBubblesWidgetState();
}

class _ChatBubblesWidgetState extends State<ChatBubblesWidget> {
  @override
  Widget build(BuildContext context) {
    var currUserId = FirebaseProvider.currUserId;

    return widget.msg.fromId == currUserId ? fromMsgWidget() : toMsgWidget();
  }

  //yellow
  Widget fromMsgWidget() {
    var sentTime = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(int.parse(widget.msg.sent)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(
                left: 50,
                right: 10,
                top: 5,
                bottom: 5), // Adjust these values as needed
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(widget.msg.message),
                ),
                wSpace(mWidth: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${sentTime.format(context)}',
                      style: TextStyle(fontSize: 10),
                    ),
                    wSpace(mWidth: 5),
                    Visibility(
                        visible: widget.msg.read != "",
                        child: Text(widget.msg.read == ""
                            ? ""
                            : TimeOfDay.fromDateTime(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(widget.msg.read)))
                                .format(context)
                                .toString())),
                    wSpace(mWidth: 5),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.done_all_outlined,
                        size: 16,
                        color:
                            widget.msg.read != "" ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //blue
  Widget toMsgWidget() {
    ///updateReadStatus
    if (widget.msg.read == "") {
      FirebaseProvider.updateReadTime(widget.msg.mId, widget.msg.fromId);
    }

    var sentTime = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(int.parse(widget.msg.sent)));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.all(11),
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),
                    bottomRight: Radius.circular(21))),
            child: Text(widget.msg.message),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text('${sentTime.format(context)}'),
        ),
      ],
    );
  }
}
