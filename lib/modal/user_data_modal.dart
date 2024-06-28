class UserDataModal {
  String? userId;
  String uFirstName;
  String uLastName;
  String uEmail;
  String uPhoneNumber;
  String uProfilePic;
  bool isActive;
  bool isOnline;

  UserDataModal(
      {this.userId,
      required this.uFirstName,
      required this.uLastName,
      required this.uEmail,
      required this.uPhoneNumber,
      this.uProfilePic = '',
      this.isActive = true,
      this.isOnline = false});

  factory UserDataModal.fromJson(Map<String, dynamic> json) {
    return UserDataModal(
        userId: json['userId'],
        uFirstName: json['uFirstName'],
        uLastName: json['uLastName'],
        uEmail: json['uEmail'],
        uPhoneNumber: json['uPhoneNumber'],
        isActive: json['isActive'],
        isOnline: json['isOnline'],
        uProfilePic: json['uProfilePic']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'uFirstName': uFirstName,
      'uLastName': uLastName,
      'uEmail': uEmail,
      'uPhoneNumber': uPhoneNumber,
      'isActive': isActive,
      'isOnline': isOnline,
      'uProfilePic': uProfilePic
    };
  }
}
