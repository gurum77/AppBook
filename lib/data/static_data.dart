import 'package:device_apps/device_apps.dart';

class StaticData {
  static String _searchingPackageName;
  // ignore: non_constant_identifier_names
  static String get SearchingPackageName => _searchingPackageName;
  // ignore: non_constant_identifier_names
  static set SearchingPackageName(var packageName) =>
      _searchingPackageName = packageName;

  // 검색중인지?
  static bool isSearching() {
    // 검색중이 아니라면 그냥 리턴
    if (StaticData.SearchingPackageName == null ||
        StaticData.SearchingPackageName.isEmpty) {
      return false;
    }
    return true;
  }

  static String _currentIconUrl;
  // ignore: non_constant_identifier_names
  static String get CurrentIconUrl => _currentIconUrl;
  // ignore: non_constant_identifier_names
  static set CurrentIconUrl(var pn) => _currentIconUrl = pn;

  static Application _currentApplication;
  // ignore: non_constant_identifier_names
  static Application get CurrentApplication => _currentApplication;
  // ignore: non_constant_identifier_names
  static set CurrentApplication(var ca) => _currentApplication = ca;

  static String _currentEmail;
  // ignore: non_constant_identifier_names
  static String get CurrentEmail => _currentEmail;
  // ignore: non_constant_identifier_names
  static set CurrentEmail(var email) => _currentEmail = email;

  // 설치되어 있는 앱들
  static Map<String, Application> _myApps = Map<String, Application>();
  static Map<String, Application> get MyApps => _myApps;
}
