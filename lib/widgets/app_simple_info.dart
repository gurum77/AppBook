import 'package:appbook/helpers/get_app_detail.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class AppSimpleInfo extends StatelessWidget {
  const AppSimpleInfo({
    Key key,
    @required this.app,
  }) : super(key: key);

  final Application app;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text('Version: ${app.versionName}'),
          // Text(
          //     'Installed: ${DateTime.fromMillisecondsSinceEpoch(app.installTimeMillis).toString()}'),
          FutureBuilder(
            future: getAppCommentCount(app.packageName),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                    child: Container(
                  width: 15,
                  height: 15,
                  margin: EdgeInsets.all(0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ));
              } else {
                return Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.comment,
                        color: Colors.blueGrey,
                        size: 17,
                      ),
                      SizedBox(width: 10,),
                      Container(
                        child: Text(
                          '${snapshot.data}',
                          style: TextStyle(
                              color: Colors.blueGrey, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      );
  }
}