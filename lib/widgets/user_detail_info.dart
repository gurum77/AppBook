import 'package:appbook/data/define.dart';
import 'package:appbook/data/static_data.dart';
import 'package:appbook/data/user_data.dart';
import 'package:appbook/helpers/db_get_helper.dart';
import 'package:flutter/material.dart';

class UserDetailInfoRow extends StatelessWidget {
  const UserDetailInfoRow({
    Key key,
  }) : super(key: key);

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
                  Text('Likes', style: TextStyle(fontSize: 20))
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Column(
                children: <Widget>[
                  Text(userData.unlike == null ? '0' : userData.unlike.toString(),
                      style: TextStyle(fontSize: 20)),
                  Text('Unlikes', style: TextStyle(fontSize: 20))
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Column(
                children: <Widget>[
                  Text(userData.reply == null ? '0' : userData.reply.toString(), style: TextStyle(fontSize: 20)),
                  Text('Replies', style: TextStyle(fontSize: 20))
                ],
              )
            ],
          );
        }
      },
    );
  }
}
