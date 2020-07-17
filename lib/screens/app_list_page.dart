import 'dart:async';
import 'dart:convert';

import 'package:appbook/data/static_data.dart';
import 'package:appbook/helpers/category_icons.dart';
import 'package:appbook/helpers/get_app_list.dart';
import 'package:appbook/widgets/app_column.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildSearthAppBar(),
      drawer: buildCategoryDrawer(context),
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

  // category 를 지정하는 drawer를 생성
  Drawer buildCategoryDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: CategoryIcons.getIcon(ApplicationCategory.audio, true),
            title: Text('All applications'.tr()),
            onTap: () =>
                changeCurrentCategory(context, ApplicationCategory.game, true),
          ),
          ListTile(
            leading: CategoryIcons.getIcon(ApplicationCategory.game, false),
            title: Text(ApplicationCategory.game
                .toString()
                .replaceAll('ApplicationCategory.', '')
                .tr()),
            onTap: () =>
                changeCurrentCategory(context, ApplicationCategory.game, false),
          ),
          ListTile(
            leading: CategoryIcons.getIcon(ApplicationCategory.audio, false),
            title: Text(ApplicationCategory.audio
                .toString()
                .replaceAll('ApplicationCategory.', '')
                .tr()),
            onTap: () => changeCurrentCategory(
                context, ApplicationCategory.audio, false),
          ),
          ListTile(
            leading: CategoryIcons.getIcon(ApplicationCategory.video, false),
            title: Text(ApplicationCategory.video
                .toString()
                .replaceAll('ApplicationCategory.', '')
                .tr()),
            onTap: () => changeCurrentCategory(
                context, ApplicationCategory.video, false),
          ),
          ListTile(
            leading: CategoryIcons.getIcon(ApplicationCategory.image, false),
            title: Text(ApplicationCategory.image
                .toString()
                .replaceAll('ApplicationCategory.', '')
                .tr()),
            onTap: () => changeCurrentCategory(
                context, ApplicationCategory.image, false),
          ),
          ListTile(
            leading: CategoryIcons.getIcon(ApplicationCategory.social, false),
            title: Text(ApplicationCategory.social
                .toString()
                .replaceAll('ApplicationCategory.', '')
                .tr()),
            onTap: () => changeCurrentCategory(
                context, ApplicationCategory.social, false),
          ),
          ListTile(
            leading: CategoryIcons.getIcon(ApplicationCategory.news, false),
            title: Text(ApplicationCategory.news
                .toString()
                .replaceAll('ApplicationCategory.', '')
                .tr()),
            onTap: () =>
                changeCurrentCategory(context, ApplicationCategory.news, false),
          ),
          ListTile(
            leading: CategoryIcons.getIcon(ApplicationCategory.maps, false),
            title: Text(ApplicationCategory.maps
                .toString()
                .replaceAll('ApplicationCategory.', '')
                .tr()),
            onTap: () =>
                changeCurrentCategory(context, ApplicationCategory.maps, false),
          ),
           ListTile(
            leading: CategoryIcons.getIcon(ApplicationCategory.productivity, false),
            title: Text(ApplicationCategory.productivity
                .toString()
                .replaceAll('ApplicationCategory.', '')
                .tr()),
            onTap: () =>
                changeCurrentCategory(context, ApplicationCategory.productivity, false),
          ),
          ListTile(
            leading: Icon(Icons.error),
            title: Text(ApplicationCategory.undefined
                .toString()
                .replaceAll('ApplicationCategory.', '')
                .tr()),
            onTap: () => changeCurrentCategory(
                context, ApplicationCategory.undefined, false),
          ),
        ],
      ),
    );
  }

  // search app bar 위젯
  AppBar buildSearthAppBar() {
    _searchTextController.text = StaticData.searchingPackageName;
    return AppBar(
      // drawer icon을 변경하기 위해서는 appbar의 leading을 설정한다.
      leading: IconButton(
        icon: CategoryIcons.getIcon(StaticData.currentCategory, StaticData.allCategory),
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
          hintText: 'Search applications'.tr(),
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

  // 카테고리를 변경하고, 앱 리스트를 갱신한다.
  void changeCurrentCategory(
      BuildContext context, ApplicationCategory category, bool allCategory) {
    // drawer를 닫는다.
    Navigator.pop(context);

    // page를 갱신한다
    setState(() {
      if (allCategory)
        StaticData.allCategory = allCategory;
      else {
        StaticData.allCategory = false;
        StaticData.currentCategory = category;
      }
    });
  }
}
