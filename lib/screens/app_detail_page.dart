import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppDetailPage extends StatelessWidget {
  var db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    if (StaticData.CurrentApplication == null) {
      return Scaffold(
        body: Center(
          child: Text('None application'),
        ),
      );
    } else {
      Application app = StaticData.CurrentApplication;

      // db 추가
      var collection = db.collection('app_detail');
      var doc = collection.document(app.packageName);
      doc.setData(
          {'category': 'game', 'installed': app.installTimeMillis.toString(), 'comments' : 'array-contains'});
          doc.updateData({'comments' : FieldValue.arrayUnion(['a','b'])});

      

      return Scaffold(
        appBar: AppBar(title: Text('AppBook')),
        body: Center(
          child: Column(
            children: <Widget>[
              app is ApplicationWithIcon
                  ? CircleAvatar(
                      backgroundImage: MemoryImage(app.icon),
                      backgroundColor: Colors.white,
                      radius: 70,
                    )
                  : Text('No icon'),
              Text(
                '${app.appName} (${app.packageName})',
                style: TextStyle(fontSize: 19),
              ),
              Text('Version: ${app.versionName}\n'
                  'System app: ${app.systemApp}\n'
                  'APK file path: ${app.apkFilePath}\n'
                  'Data dir: ${app.dataDir}\n'
                  'Installed: ${DateTime.fromMillisecondsSinceEpoch(app.installTimeMillis).toString()}\n'
                  'Updated: ${DateTime.fromMillisecondsSinceEpoch(app.updateTimeMillis).toString()}'),
            ],
          ),
        ),
      );
    }
  }
}
