import 'dart:convert';

import 'package:appbook/data/comment_data.dart';
import 'package:appbook/data/static_data.dart';
import 'package:appbook/helpers/db_upload_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentListTile extends StatelessWidget {
  CommentListTile({
    Key key,
    @required this.position,
    @required this.comment,
  }) : super(key: key);

  final int position;
  final String comment;
  CommentData commentData;

  @override
  Widget build(BuildContext context) {
    CommentData commentData;
    try {
      var json = jsonDecode(comment);
      commentData = CommentData.fromJson(json);
    } catch (e) {
      commentData = CommentData(comment, 'unknown', 0, 0);
    }

    return ListTile(
      leading: Text((position + 1).toString()),
      title: Text(commentData.content),
      subtitle: CommentInfo(commentData),
    );
  }
}

// comment 정보를 표시하는 위젯
class CommentInfo extends StatefulWidget {
  CommentData commentData;
  CommentInfo(
    this.commentData, {
    Key key,
  }) : super(key: key);

  @override
  _CommentInfoState createState() => _CommentInfoState();
}

class _CommentInfoState extends State<CommentInfo> {
  @override
  Widget build(BuildContext context) {
    double height = 15;
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_upward,
            size: height,
            color: Colors.red,
          ),
          onPressed: onPressedLike,
        ),
        Text(widget.commentData.like.toString(),
            style: TextStyle(fontSize: height)),
        IconButton(
          icon: Icon(
            Icons.arrow_downward,
            size: height,
            color: Colors.blue,
          ),
          onPressed: onPressedUnlike,
        ),
        Text(widget.commentData.unlike.toString(),
            style: TextStyle(fontSize: height)),
        SizedBox(
          width: 10,
        ),
        Icon(Icons.person),
        SizedBox(
          width: 5,
        ),
        Expanded(
            child: Text(
          widget.commentData.author,
          softWrap: false,
        )),
      ],
    );
  }

  void onPressedLikeOrUnlike(bool isLike) async {
    bool available = await checkClickAvailable();

    if (available) {
      if (isLike)
        widget.commentData.like++;
      else
        widget.commentData.unlike++;

      // 작성자의 like또는 unlike를 갱신
      uploadLikeOrUnlikeAdded(
          widget.commentData.author, isLike);

      setState(() {
        uploadChangedComment(
            StaticData.currentApplication.packageName, widget.commentData);
      });
    }
  }

  void onPressedUnlike() async => onPressedLikeOrUnlike(false);
  void onPressedLike() async => onPressedLikeOrUnlike(true);

  Future<bool> isClicked() async {
    // SharedPreferences.setMockInitialValues({});
    final ref = await SharedPreferences.getInstance();
    final isChecked = ref.getBool(widget.commentData.id);
    if (isChecked == null) return false;
    return true;
  }

  Future<void> setClicked() async {
    final ref = await SharedPreferences.getInstance();
    ref.setBool(widget.commentData.id, true);
  }

  // 클릭이 가능한지 체크한다.
  Future<bool> checkClickAvailable() async {
    // 이미 눌렀는지 체크
    bool clicked = await isClicked();
    if (clicked) {
      // 이미 눌렀다면 통과
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Icon(Icons.report_problem),
                content: Text('Click once'),
              ));
      return false;
    } else {
      setClicked();
      return true;
    }
  }
}
