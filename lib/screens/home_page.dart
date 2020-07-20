import 'package:appbook/custom_paint.dart/home_page_background.dart';
import 'package:appbook/widgets/user_detail_info.dart';
import 'package:appbook/widgets/user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // home page에 들어오면 키보드를 내려야 함
    FocusScope.of(context).unfocus();

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: size,
            painter: HomePageBackground(),
          ),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                width: size.width,
                child: UserInfo(
                  size: size,
                ),
              ),
              Container(
                width: size.width * 0.70,
                child: Divider(
                  thickness: 3,
                  color: Colors.purple,
                ),
              ),
              Container(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  children: List.generate(30, (index) {
                    return Card(
                      elevation: 10,
                      color: Colors.green[100],
                      shadowColor: Colors.black,
                      margin: EdgeInsets.all(15),
                      shape: CircleBorder(),
                      child: Align(
                        child: Text('${index + 1}',
                            style: TextStyle(fontSize: 25)),
                        alignment: Alignment.center,
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  getBadge() {}
}
