import 'dart:typed_data';

import 'package:appbook/data/static_data.dart';
import 'package:appbook/screens/app_detail_page.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import 'app_simple_info.dart';

class AppColumn extends StatefulWidget {
  const AppColumn({Key key, @required this.app, @required this.context})
      : super(key: key);

  final Application app;
  final BuildContext context;

  @override
  _AppColumnState createState() => _AppColumnState();
}

class _AppColumnState extends State<AppColumn> {
  @override
  Widget build(BuildContext context) {
    Application appTmp = this.widget.app;
    return Column(
      children: <Widget>[
        ListTile(
            leading: appTmp is ApplicationWithIcon
                ? CircleAvatar(
                    backgroundImage: MemoryImage(appTmp.icon),
                    backgroundColor: Colors.white,
                  )
                : FutureBuilder(
                    future: getApplicationIconInDevice(widget.app.packageName),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return CircularProgressIndicator();
                      } else {
                        return CircleAvatar(
                          backgroundImage: MemoryImage(snapshot.data),
                          backgroundColor: Colors.white,
                        );
                      }
                    },
                  ),
            // onTap: () => DeviceApps.openApp(app.packageName),
            onTap: () {
              StaticData.currentApplication = appTmp;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppDetailPage(),
                  )).then((value) {
                setState(() {});
              });
            },
            title: widget.app == null
                ? Text('null')
                // : Text("${app.appName} (${app.packageName})"),
                : Text(
                    '${widget.app.appName}',
                    style: TextStyle(fontSize: 17),
                  ),
            trailing: Container(
                width: 50,
                height: 20,
                child: AppSimpleInfo(
                  app: widget.app,
                ))),
        Divider(
          height: 1.0,
        )
      ],
    );
  }

  Future<Uint8List> getApplicationIconInDevice(String packageName) async {
    // myapps에서 미리 찾아 본다.
    Application myApp = StaticData.myApps[packageName];
    if (myApp != null && myApp is ApplicationWithIcon) {
      return myApp.icon;
    }

    // 없으면 읽어온다.
    Application app = await DeviceApps.getApp(packageName, true);

    if (app is ApplicationWithIcon) {
      // my apps 에 추가
      if (myApp != null) {
        StaticData.myApps[packageName] = app;
      }

      return app.icon;
    }

    return null;
  }
}
