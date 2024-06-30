
class MessageModel {
  String fromId;
  String mId;
  String message;
  String msgType;
  String read;
  String sent;
  String toId;

  MessageModel({required this.fromId,
      required this.mId,
      required this.message,
      this.msgType = "text",
      this.read = "",
      required this.sent,
      required this.toId});



  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      fromId: json['fromId'],
      mId: json['mId'],
      message: json['message'],
      msgType: json['msgType'],
      read: json['read'],
      sent: json['sent'],
      toId: json['toId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromId':fromId,
      'mId':mId,
      'message':message,
      'msgType':msgType,
      'read':read,
      'sent':sent,
      'toId':toId,
    };
  }

}
