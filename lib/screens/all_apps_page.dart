import 'dart:typed_data';

import 'package:appbook/data/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import 'app_detail_page.dart';
import 'package:http/http.dart' as http;

class AllAppsPage extends StatelessWidget {
  var db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    var collection = db.collection('app_detail');

    return FutureBuilder(
      future: collection.getDocuments(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(itemBuilder: (context, position) {
            QuerySnapshot docSnapshot = snapshot.data;
            if (position < docSnapshot.documents.length) {
              var doc = docSnapshot.documents[position];
              String packageName = doc.documentID;
              String versionName = doc.data['version_name'];
              int installTime = doc.data['install_time'];
              int category = doc.data['category'];
              String icon_url = doc.data['icon_url'];
              // https://lh3.googleusercontent.com/

              return Column(
                children: <Widget>[
                  icon_url == null ? Text('no icon') : Image.network(icon_url),
                  ListTile(
                    title: Text(packageName),

                    // onTap: () => DeviceApps.openApp(app.packageName),
                    onTap: () {
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
                          Map<dynamic, dynamic> map = {
                            'app_name': 'name',
                            'apk_file_path': 'apk_file_path',
                            'package_name': packageName,
                            'version_name': versionName,
                            'version_code': 1,
                            'data_dir': 'data_dir',
                            'system_app': false,
                            'install_time': installTime,
                            'update_time': 1939293728281,
                            'category': category,
                          };
                          try {
                            StaticData.CurrentApplication = Application(map);
                            StaticData.CurrentIconUrl = icon_url;
                          } catch (e) {
                            print(e.toString());
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppDetailPage(),
                              ));
                        }
                      });
                    },
                  ),
                ],
              );
            }
          });
        }
      },
    );
  }
}
