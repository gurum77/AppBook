import 'dart:convert';

import 'package:uuid/uuid.dart';

class CommentData {
  CommentData(this.content, this.author, this.like, this.unlike){
    this.id = Uuid().v1();
  
  }

  static CommentData fromString(String str){
    try{
        var json = jsonDecode(str);
        return CommentData.fromJson(json);
    }
    catch(e)
    {
      return CommentData(str, 'unknown', 0, 0);
    }
  }
  CommentData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        author = json['author'],
        like = json['like'],
        unlike = json['unlike'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'author': author,
        'like': like,
        'unlike': unlike
      };
  String id;
  String content;
  String author;
  int like;
  int unlike;
}
