import 'package:appbook/data/static_data.dart';
import 'package:flutter/material.dart';

class UserSimpleInfoRow extends StatelessWidget {
  const UserSimpleInfoRow({Key key, this.size}) : super(key: key);
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Card(
          shape:CircleBorder(),
          margin: EdgeInsets.all(0),
          elevation: 10,
          child: CircleAvatar(
            maxRadius: size.width * 0.15,
            // backgroundImage: NetworkImage('https://picsum.photos/200'),
            backgroundImage: AssetImage('assets/login.gif'),
          ),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(
            // color: Colors.red,
            width: size.width - (size.width * 0.15 * 2) - 40,
            height: size.width * 0.15 / 2,
            child: Text(
              'LV. 100',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.end,
            ),
          ),
          Container(
              // color: Colors.yellow,
              padding: EdgeInsets.all(7),
              width: 100,
              height: size.width * 0.15 / 2,
              child: LinearProgressIndicator(
                backgroundColor: Colors.black,
                value: 0.6,
              )),
          Container(
            // color:Colors.blue,
            width: size.width - (size.width * 0.15 * 2) - 40,
            height: size.width * 0.15 / 2,
          ),
          Container(
            // color:Colors.green,
            width: size.width - (size.width * 0.15 * 2) - 40,
            height: size.width * 0.15 / 2,
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
