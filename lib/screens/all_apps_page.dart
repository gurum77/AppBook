import 'dart:async';
import 'dart:convert';

import 'package:appbook/widgets/application_column.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// 모든 앱 보기 페이지
// ignore: must_be_immutable
class AllAppsPage extends StatelessWidget {
  var db = Firestore.instance;
  StorageReference rootRef = FirebaseStorage.instance.ref().getRoot();
  StorageReference appIconsRef;
  AllAppsPage() {
    appIconsRef = rootRef.child('app_icons');
  }
  @override
  Widget build(BuildContext context) {
    var collection = db.collection('app_detail');

    return FutureBuilder(
      future: getApplications(collection),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(itemBuilder: (context, position) {
            List<Application> apps = snapshot.data;
            if (position < apps.length) {
              var app = apps[position];
              return ApplicationColumn(
                app: app,
                context: context,
              );
            }
          });
        }
      },
    );
  }

  // doc로 application을 만들어서 리턴한다.
  Application _makeApplicationByDoc(DocumentSnapshot doc, String iconData) {
    String packageName = doc.documentID;
    String appName = doc.data['app_name'];
    String versionName = doc.data['version_name'];
    int installTime = doc.data['install_time'];
    int category = doc.data['category'];
    String appIcon = doc.data['app_icon'];
    Map<dynamic, dynamic> map = {
      'app_name': appName == null ? 'no name' : appName,
      'apk_file_path': 'apk_file_path',
      'package_name': packageName == null ? 'no package name' : packageName,
      'version_name': versionName == null ? 'no version name' : versionName,
      'version_code': 1,
      'data_dir': 'data_dir',
      'system_app': false,
      'install_time': installTime == null ? 0 : installTime,
      'update_time': installTime == null ? 0 : installTime,
      'category': category == null ? -1 : category,
    };

    if (appIcon != null) {
      map['app_icon'] = appIcon;
    } else if (iconData != null) {
      map['app_icon'] = iconData;
    }

    Application app = Application(map);
    return app;
  }

  Future<List<Application>> getApplications(
      CollectionReference collection) async {
    var qs = await collection.getDocuments();
    var applications = List<Application>();

    for (var doc in qs.documents) {
      var icon = null; //await _downloadIcon(doc.documentID);
      Application app = _makeApplicationByDoc(doc, icon);
      if (app != null) {
        applications.add(app);
      }
    }

    return applications;
  }

  // icon을 download.
  Future<String> _downloadIcon(String packageName) async {
    var iconRef = appIconsRef.child(packageName);

    try {
      var iconData = await iconRef.getData(1024 * 1024);
      return base64Encode(iconData);
    } catch (e) {
      return null;
    }
  }
}
