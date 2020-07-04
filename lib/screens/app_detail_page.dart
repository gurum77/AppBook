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
      //

      // db 추가
      // var collection = db.collection('app_detail');
      // var doc = collection.document(app.packageName);
      // doc.setData(
      //     {'category': 'game', 'installed': app.installTimeMillis.toString(), 'comments' : 'array-contains'});
      //     doc.updateData({'comments' : FieldValue.arrayUnion(['a','b'])});

      Application app = StaticData.CurrentApplication;
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
              FutureBuilder(
                future: getAppComments(),
                builder: (context, snapShot) {
                  if (snapShot == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapShot.connectionState == ConnectionState.done) {
                      if (snapShot.hasError) {
                        return Text(
                          "error : " + snapShot.error.toString(),
                          style: TextStyle(color: Colors.blue, fontSize: 30),
                        );
                      }
                      List<String> comments = snapShot.data;
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, position) {
                            var comment = comments[position];
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Text(position.toString()),
                                  onTap: () {},
                                  title: Text(comment),
                                  subtitle: Text('sub'),
                                ),
                              ],
                            );
                          },
                          itemCount: comments.length,
                        ),
                      );
                    } else {
                      return Text(
                        'no data',
                        style: TextStyle(color: Colors.yellow, fontSize: 30),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      );
    }
  }

// 현재 앱의 comment를 모두 가져온다.
  Future<List<String>> getAppComments() {
    var collection = db.collection('app_detail');
    var doc = collection.document(StaticData.CurrentApplication.packageName);
    return doc.get().then((DocumentSnapshot ds) {
      var comments = List<String>();
      for (var comment in ds.data['comments']) {
        comments.add(comment.toString());
      }
      return comments;
    });
  }
}
