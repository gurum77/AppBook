
import 'package:appbook/helpers/comment_parser.dart';
import 'package:flutter/material.dart';

class CommentListTile extends StatelessWidget {
  CommentListTile({
    Key key,
    @required this.position,
    @required this.comment,
  }) : super(key: key);

  final int position;
  final String comment;
  CommentInfoData commentInfo;

  @override
  Widget build(BuildContext context) {
    commentInfo = getCommentInfoFromComment(comment);
    return ListTile(
      leading: Text((position + 1).toString()),
      title: Text(comment),
      subtitle: CommentInfo(commentInfo),
    );
  }
}

// comment 정보를 표시하는 위젯
class CommentInfo extends StatelessWidget {
  const CommentInfo(
    commentInfo, {
    Key key,
  }) : super(key: key);

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
          onPressed: () {},
        ),
        Text('0', style: TextStyle(fontSize: height)),
        SizedBox(
          width: 20,
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_downward,
            size: height,
            color: Colors.blue,
          ),
          onPressed: () {},
        ),
        Text('0', style: TextStyle(fontSize: height)),
      ],
    );
  }
}
