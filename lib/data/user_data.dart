import 'dart:convert';

class UserData {
  const UserData({this.email, this.like, this.unlike, this.reply});

  static UserData fromString(String str) {
    try {
      var json = jsonDecode(str);
      return UserData.fromJson(json);
    } catch (e) {
      return UserData(email: "unknown", like: 0, unlike: 0, reply: 0);
    }
  }

  UserData.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        like = json['like'],
        unlike = json['unlike'],
        reply = json['reply'];

  Map<String, dynamic> toJson() =>
      {'id': email, 'like': like, 'unlike': unlike, 'reply': reply};
  final String email;
  final int like;
  final int unlike;
  final int reply;
}
