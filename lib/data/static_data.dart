import 'package:device_apps/device_apps.dart';

class StaticData {
  static String  _currentIconUrl;
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
}
