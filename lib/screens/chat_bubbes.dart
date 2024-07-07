import 'package:chat_application/firebase_provider/firebase_provider.dart';
import 'package:chat_application/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:chat_application/modal/message_modal.dart';

class ChatBubblesWidget extends StatelessWidget {
  final MessageModel msg;
  final VoidCallback onDelete;

  ChatBubblesWidget({required this.msg, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    var currUserId = FirebaseProvider.currUserId;

    return GestureDetector(
      onLongPress: onDelete,
      child: msg.fromId == currUserId
          ? fromMsgWidget(context)
          : toMsgWidget(context),
    );
  }

  // yellow
  Widget fromMsgWidget(BuildContext context) {
    var sentTime = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(int.parse(msg.sent)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin:
                const EdgeInsets.only(left: 50, right: 10, top: 5, bottom: 5),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (msg.msgType == 'image')
                  Image.network(
                    msg.message,
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (msg.msgType == 'text') Text(msg.message),
                    wSpace(mWidth: 5),
                    Text(
                      '${sentTime.format(context)}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Visibility(
                      visible: msg.read != "",
                      child: Text(
                        msg.read == ""
                            ? ""
                            : TimeOfDay.fromDateTime(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(msg.read)))
                                .format(context)
                                .toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    wSpace(mWidth: 5),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        msg.status == 'read' ? Icons.done_all : Icons.done,
                        //  Icons.done_all_outlined,
                        size: 16,
                        color: msg.read != "" ? Colors.blue : Colors.grey,
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

  // blue
  Widget toMsgWidget(BuildContext context) {
    if (msg.read == "") {
      FirebaseProvider.updateReadTime(msg.mId, msg.fromId);
    }

    var sentTime = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(int.parse(msg.sent)));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.all(11),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(21),
              topRight: Radius.circular(21),
              bottomRight: Radius.circular(21),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (msg.msgType == 'image')
                Image.network(
                  msg.message,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (msg.msgType == 'text') Text(msg.message),
                  SizedBox(width: 5),
                  Text(
                    sentTime.format(context),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
