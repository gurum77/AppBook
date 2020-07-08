import 'package:appbook/data/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';

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

// 찾고 있는 앱만 리턴
List<Application> getSearchingApplicationsOnly(List<Application> apps) {
  // 검색중이 아니라면 그냥 리턴
  if (StaticData.SearchingPackageName == null ||
      StaticData.SearchingPackageName.isEmpty) {
    return apps;
  }

  var reg = RegExp(StaticData.SearchingPackageName, caseSensitive: false);
  apps.removeWhere((element) => reg.firstMatch(element.appName) == null);
  return apps;
}

// 서버에 있는 모든 앱을 리턴한다.
// 단, 서버에 있는 앱 리턴할때는 검색할때만 리턴한다.
Future<List<Application>> getApplicationsOnServer() async {
  var db = Firestore.instance;
  var collection = db.collection('app_detail');

  var qs = await collection.getDocuments();
  var applications = List<Application>();

  var reg = RegExp(StaticData.SearchingPackageName, caseSensitive: false);

  for (var doc in qs.documents) {
    // 서버에서 가져올때는 무조건 검색 결과만 가져온다
    if (reg.firstMatch(doc.data['app_name']) == null) continue;
    var icon = null; //await _downloadIcon(doc.documentID);
    Application app = _makeApplicationByDoc(doc, icon);
    if (app != null) {
      applications.add(app);
    }
  }

  return applications;
}

// 설치되어 있는 app을 모두 가져온다.
Future<List<Application>> getInstalledApplications() async {
  var apps = List<Application>();

  // 없으면 가져온다.
  // 처음에만 가져오기 대문에 검색과정과 상관없이 모두넣는다.
  // 어차피 처음에는 검색이 안된 상태로 들어오기 때문에 모두 담아도된다.
  if (StaticData.MyApps.length == 0) {
    DeviceApps.getInstalledApplications(
            includeAppIcons: false,
            includeSystemApps: true,
            onlyAppsWithLaunchIntent: true)
        .then((value) {
      apps = value;
      for (var app in apps) {
        StaticData.MyApps[app.packageName] = app;
      }
    });
  }
  // 있으면 그냥 담는다.
  else {
    apps.addAll(StaticData.MyApps.values);
    apps = getSearchingApplicationsOnly(apps);
  }

  return apps;
}
