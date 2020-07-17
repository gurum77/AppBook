import 'dart:convert';

class UserData {
  UserData(this.email,this.like, this.unlike);
    
  static UserData fromString(String str){
    try{
        var json = jsonDecode(str);
        return UserData.fromJson(json);
    }
    catch(e)
    {
      return UserData('unknown', 0, 0);
    }
  }
  UserData.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        like = json['like'],
        unlike = json['unlike'];

  Map<String, dynamic> toJson() => {
        'id': email,
        'like': like,
        'unlike': unlike
      };
  String email;
  int like;
  int unlike;
}
