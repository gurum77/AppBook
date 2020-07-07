import 'package:appbook/data/static_data.dart';
import 'package:appbook/screens/app_detail_page.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class ApplicationColumn extends StatelessWidget {
  const ApplicationColumn({
    Key key,
    @required this.app,
    @required this.context,
  }) : super(key: key);

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
                : Text(
                    'Version: ${app.versionName}\n'
                    // 'System app: ${app.systemApp}\n'
                    // 'APK file path: ${app.apkFilePath}\n'
                    // 'Data dir: ${app.dataDir}\n'
                    'Installed: ${DateTime.fromMillisecondsSinceEpoch(app.installTimeMillis).toString()}\n'
                    // 'Updated: ${DateTime.fromMillisecondsSinceEpoch(app.updateTimeMillis).toString()}')
                    ,
                  )),
        Divider(
          height: 1.0,
        )
      ],
    );
  }
}
