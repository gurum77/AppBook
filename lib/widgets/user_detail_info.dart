import 'package:appbook/data/static_data.dart';
import 'package:appbook/data/user_data.dart';
import 'package:appbook/helpers/db_get_helper.dart';
import 'package:appbook/helpers/db_upload_helper.dart';
import 'package:flutter/material.dart';

class UserDetailInfoRow extends StatefulWidget {
  const UserDetailInfoRow({
    Key key,
  }) : super(key: key);

  @override
  _UserDetailInfoRowState createState() => _UserDetailInfoRowState();
}

class _UserDetailInfoRowState extends State<UserDetailInfoRow> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserData(StaticData.currentEmail),
      builder: (context, snapshot) {
        if (snapshot.data == null)
          return CircularProgressIndicator();
        else {
          UserData userData = snapshot.data;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(userData.like == null ? '0' : userData.like.toString(),
                      style: TextStyle(fontSize: 20)),
                  Text('Likes', style: TextStyle(fontSize: 20)),
                ],
              ),
              Container(
                width: 50,
                child: buildNewIconButton(true),
              ),
              Column(
                children: <Widget>[
                  Text(
                      userData.unlike == null
                          ? '0'
                          : userData.unlike.toString(),
                      style: TextStyle(fontSize: 20)),
                  Text('Unlikes', style: TextStyle(fontSize: 20))
                ],
              ),
              Container(
                width: 50,
                child: buildNewIconButton(false),
              ),
              Column(
                children: <Widget>[
                  Text(userData.reply == null ? '0' : userData.reply.toString(),
                      style: TextStyle(fontSize: 20)),
                  Text('Replies', style: TextStyle(fontSize: 20))
                ],
              )
            ],
          );
        }
      },
    );
  }

  IconButton buildNewIconButton(bool isLike) {
    int count =
        isLike ? StaticData.userData.newLike : StaticData.userData.newUnlike;
    return count == null || count == 0
        ? null
        : IconButton(
            icon: Icon(Icons.fiber_new),
            color: Colors.red,
            iconSize: 30,
            onPressed: () {
              if (isLike) {
                StaticData.userData = UserData(
                    like:
                        StaticData.userData.like + StaticData.userData.newLike,
                    unlike: StaticData.userData.unlike,
                    newLike: 0,
                    newUnlike: StaticData.userData.newUnlike,
                    reply: StaticData.userData.reply);
              } else {
                StaticData.userData = UserData(
                    like: StaticData.userData.like,
                    unlike: StaticData.userData.unlike +
                        StaticData.userData.newUnlike,
                    newLike: StaticData.userData.newLike,
                    newUnlike: 0,
                    reply: StaticData.userData.reply);
              }

              uploadUserData().then((value) => setState(() {}));
            },
          );
  }
}
