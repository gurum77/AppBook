import 'dart:async';
import 'dart:convert';

import 'package:appbook/data/static_data.dart';
import 'package:appbook/widgets/application_column.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'app_detail_page.dart';
import 'package:http/http.dart' as http;

// 모든 앱 보기 페이지
// ignore: must_be_immutable
class AllAppsPage extends StatelessWidget {
  var db = Firestore.instance;

  Future<List<Application>> getApplications(
      CollectionReference collection) async {
    var qs = await collection.getDocuments();

    var applications = List<Application>();

    for (var doc in qs.documents) {
      var icon = await _downloadIcon(doc.documentID);
      Application app = _makeApplicationByDoc(doc, icon);
      if (app != null) {
        applications.add(app);
      }
    }

    return applications;
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
  Application _makeApplicationByDoc(DocumentSnapshot doc, Icon icon) {
    String packageName = doc.documentID;
    String appName = doc.data['app_name'];
    String versionName = doc.data['version_name'];
    int installTime = doc.data['install_time'];
    int category = doc.data['category'];
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

    if (icon != null) {
      map['app_icoin'] = icon;
    }

    Application app = Application(map);
    return app;
  }

  // package name을 tap했을때..
  onTapPackageName(DocumentSnapshot doc, BuildContext context) {
    String packageName = doc.documentID;
    DeviceApps.isAppInstalled(packageName).then((value) {
      // 설치되어 있다면...
      if (value) {
        DeviceApps.getApp(packageName, true).then((value) {
          StaticData.CurrentApplication = value;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppDetailPage(),
              ));
        });
        // 설치되어 있지 않다면...
        // db 정보로 application 클래스를 만들어서 상세페이지로 이동
      } else {
        // doc로 application을 만든다.
        StaticData.CurrentApplication = _makeApplicationByDoc(doc);

        // 상세 페이지로 이동
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppDetailPage(),
            ));
      }
    });
  }

  // icon을 download.
  Future<Icon> _downloadIcon(String packageName) async {
    final StorageReference storageReference =
        FirebaseStorage().ref().child('/app_icons/' + packageName);
    // final String url = await storageReference.getDownloadURL();

    return null;
  }
}
