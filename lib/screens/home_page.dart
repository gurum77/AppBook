import 'package:appbook/data/static_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // home page에 들어오면 키보드를 내려야 함
    FocusScope.of(context).unfocus();

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Container(
            // color: Colors.red,
            height: 100,
            child: Text(
              'Lv. 100',
              style: TextStyle(color: Colors.red, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            child: FittedBox(
              child: CircleAvatar(
                // backgroundImage: NetworkImage('https://picsum.photos/200'),
                backgroundImage: AssetImage('assets/login.gif'),
              ),
            ),
            width: size.width,
            height: 290,
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            // color:Colors.yellow,
            child: Center(
              child: Text(
                StaticData.currentEmail == null
                    ? 'Unknown user'
                    : StaticData.currentEmail,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
