import 'package:appbook/screens/app_detail_page.dart';
import 'package:appbook/data/static_data.dart';
import 'package:appbook/widgets/application_column.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class MyAppsPage extends StatefulWidget {
  @override
  _MyAppsPageState createState() => _MyAppsPageState();
}

class _MyAppsPageState extends State<MyAppsPage> {
  bool _showSystemApps = false;
  bool _onlyLaunchableApps = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Installed applications"),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) {
              return <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                    value: 'system_apps', child: Text('Toggle system apps')),
                PopupMenuItem<String>(
                  value: "launchable_apps",
                  child: Text('Toggle launchable apps only'),
                )
              ];
            },
            onSelected: (key) {
              if (key == "system_apps") {
                setState(() {
                  _showSystemApps = !_showSystemApps;
                });
              }
              if (key == "launchable_apps") {
                setState(() {
                  _onlyLaunchableApps = !_onlyLaunchableApps;
                });
              }
            },
          )
        ],
      ),
      body: _ListAppsPagesContent(
          includeSystemApps: _showSystemApps,
          onlyAppsWithLaunchIntent: _onlyLaunchableApps,
          key: GlobalKey()),
    );
  }
}

class _ListAppsPagesContent extends StatelessWidget {
  final bool includeSystemApps;
  final bool onlyAppsWithLaunchIntent;

  const _ListAppsPagesContent(
      {Key key,
      this.includeSystemApps: false,
      this.onlyAppsWithLaunchIntent: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DeviceApps.getInstalledApplications(
            includeAppIcons: true,
            includeSystemApps: includeSystemApps,
            onlyAppsWithLaunchIntent: onlyAppsWithLaunchIntent),
        builder: (context, data) {
          if (data.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<Application> apps = data.data;
            print(apps);
            return ListView.builder(
                itemBuilder: (context, position) {
                  Application app = apps[position];
                  return ApplicationColumn(app: app, context: context);
                },
                itemCount: apps.length);
          }
        });
  }

  // application 1개에 대한 column을 만든다.
}

