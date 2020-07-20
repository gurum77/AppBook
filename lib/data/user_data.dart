import 'dart:convert';

class UserData {
  const UserData(
      {this.like, this.unlike, this.reply, this.newLike, this.newUnlike});

  static UserData fromString(String str) {
    try {
      var json = jsonDecode(str);
      return UserData.fromJson(json);
    } catch (e) {
      return UserData(like: 0, unlike: 0, reply: 0, newLike: 0, newUnlike: 0);
    }
  }

  UserData.fromJson(Map<String, dynamic> json)
      : like = json['like'],
        unlike = json['unlike'],
        reply = json['reply'],
        newLike = json['new_like'],
        newUnlike = json['new_unlike'];

  Map<String, dynamic> toJson() => {
        'like': like,
        'unlike': unlike,
        'reply': reply,
        'new_like': newLike,
        'new_unlike': newUnlike
      };
  final int like;
  final int unlike;
  final int reply;
  final int newLike;
  final int newUnlike;
}
