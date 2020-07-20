import 'package:appbook/data/static_data.dart';
import 'package:appbook/helpers/db_get_helper.dart';
import 'package:appbook/helpers/level_manager.dart';
import 'package:appbook/widgets/user_detail_info.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key key, this.size}) : super(key: key);
  final Size size;

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    // user simple info를 만들때 마다 user data를 읽는다.
    getUserData(StaticData.currentEmail);
    return Column(
      children: <Widget>[
        buildUserBasicInfoRow(),
        Container(width: 200, height:20,),
        UserDetailInfoRow(),
      ],
    );
  }

  Row buildUserBasicInfoRow() {
    return Row(
        children: <Widget>[
          Card(
            shape: CircleBorder(),
            margin: EdgeInsets.all(0),
            elevation: 10,
            child: CircleAvatar(
              maxRadius: widget.size.width * 0.15,
              // backgroundImage: NetworkImage('https://picsum.photos/200'),
              backgroundImage: AssetImage('assets/login.gif'),
            ),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              // color: Colors.red,
              width: widget.size.width - (widget.size.width * 0.15 * 2) - 40,
              height: widget.size.width * 0.15 / 2,
              child: Text(
                'LV. ${LevelManager.getLevel()}, Exp. ${LevelManager.getExp()}',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.end,
              ),
            ),
            Container(
                // color: Colors.yellow,
                padding: EdgeInsets.all(7),
                width: 100,
                height: widget.size.width * 0.15 / 2,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.black,
                  value: LevelManager.calcRemainExpRateForNextLevel(),
                )),
            Container(
              // color:Colors.blue,
              width: widget.size.width - (widget.size.width * 0.15 * 2) - 40,
              height: widget.size.width * 0.15 / 2,
            ),
            Container(
              // color:Colors.green,
              width: widget.size.width - (widget.size.width * 0.15 * 2) - 40,
              height: widget.size.width * 0.15 / 2,
              child: Text(
                StaticData.currentEmail,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.right,
              ),
            ),
          ]),
        ],
      );
  }
}
