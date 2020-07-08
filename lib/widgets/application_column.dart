import 'package:appbook/data/static_data.dart';
import 'package:appbook/helpers/get_app_detail.dart';
import 'package:appbook/screens/app_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class ApplicationColumn extends StatelessWidget {
  const ApplicationColumn({Key key, @required this.app, @required this.context})
      : super(key: key);

  final Application app;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    Application appTmp = this.app;
    return Column(
      children: <Widget>[
        ListTile(
            leading: appTmp is ApplicationWithIcon
                ? CircleAvatar(
                    backgroundImage: MemoryImage(appTmp.icon),
                    backgroundColor: Colors.white,
                  )
                : null,
            // onTap: () => DeviceApps.openApp(app.packageName),
            onTap: () {
              StaticData.CurrentApplication = appTmp;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppDetailPage(),
                  ));
            },
            title: app == null
                ? Text('null')
                : Text("${app.appName} (${app.packageName})"),
            subtitle: app == null
                ? Text('null')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Version: ${app.versionName}'),
                      Text(
                          'Installed: ${DateTime.fromMillisecondsSinceEpoch(app.installTimeMillis).toString()}'),
                      FutureBuilder(
                        future: getAppCommentCount(app.packageName),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return Text('Comments:${snapshot.data}');
                          }
                        },
                      ),
                    ],
                  )),
        Divider(
          height: 1.0,
        )
      ],
    );
  }
}
