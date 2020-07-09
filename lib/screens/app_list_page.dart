import 'dart:async';
import 'dart:convert';

import 'package:appbook/data/static_data.dart';
import 'package:appbook/helpers/get_app_list.dart';
import 'package:appbook/widgets/app_column.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// 모든 앱 보기 페이지
// ignore: must_be_immutable
class ApplicationListPage extends StatefulWidget {
  bool _installedApplications;
  ApplicationListPage(bool installedApplications) {
    this._installedApplications = installedApplications;
  }

  @override
  _ApplicationListPageState createState() => _ApplicationListPageState();
}

class _ApplicationListPageState extends State<ApplicationListPage> {
  var _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearthAppBar(),
      body: FutureBuilder(
        future: widget._installedApplications
            ? getInstalledApplications()
            : getApplicationsOnServer(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(itemBuilder: (context, position) {
              List<Application> apps = snapshot.data;
              if (position < apps.length) {
                var app = apps[position];
                return AppColumn(
                  app: app,
                  context: context,
                );
              } else
                return null;
            });
          }
        },
      ),
    );
  }

  // search app bar 위젯
  AppBar buildSearthAppBar() {
    _searchTextController.text = StaticData.searchingPackageName;
    return AppBar(
      backgroundColor: Colors.blue[100],
      title: TextField(
        onChanged: (text) {
          StaticData.searchingPackageName = text;
        },
        onSubmitted: (text) {
          // 찾는다.
          setState(() {
            StaticData.searchingPackageName = text;
          });
        },
        autofocus: false,
        controller: _searchTextController,
        decoration: InputDecoration(
          hintText: 'Search applications',
          suffixIcon: FlatButton(
            child: Icon(Icons.search),
            onPressed: () {
              // 찾는다.
              setState(() {
                StaticData.searchingPackageName = _searchTextController.text;
              });
            },
          ),
        ),
      ), // Text("Installed applications"),
    );
  }

  //
  // ignore: unused_element
  Future<String> _downloadIcon(String packageName) async {
    StorageReference rootRef = FirebaseStorage.instance.ref().getRoot();
    StorageReference appIconsRef;

    appIconsRef = rootRef.child('app_icons');
    var iconRef = appIconsRef.child(packageName);

    try {
      var iconData = await iconRef.getData(1024 * 1024);
      return base64Encode(iconData);
    } catch (e) {
      return null;
    }
  }
}
