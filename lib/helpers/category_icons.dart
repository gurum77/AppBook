import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class CategoryIcons {
  static Map<ApplicationCategory, Icon> _iconsByCategory;

  static Icon _allApplicationsIcon;

  // icons을 만든다.
  static void _makeIcons() {
    if (_iconsByCategory != null) return;

    _allApplicationsIcon = Icon(Icons.apps, color: Colors.black,);

    _iconsByCategory = Map<ApplicationCategory, Icon>();
    _iconsByCategory[ApplicationCategory.audio] = Icon(Icons.audiotrack, color: Colors.orange,);
    _iconsByCategory[ApplicationCategory.game] = Icon(Icons.games, color: Colors.blue,);
    _iconsByCategory[ApplicationCategory.image] = Icon(Icons.image, color:Colors.purple);
    _iconsByCategory[ApplicationCategory.maps] = Icon(Icons.map, color:Colors.brown);
    _iconsByCategory[ApplicationCategory.news] = Icon(Icons.next_week, color:Colors.red);
    _iconsByCategory[ApplicationCategory.productivity] = Icon(Icons.work, color:Colors.green);
    _iconsByCategory[ApplicationCategory.social] = Icon(Icons.people, color:Colors.lime);
    _iconsByCategory[ApplicationCategory.video] = Icon(Icons.videocam, color:Colors.teal);
    _iconsByCategory[ApplicationCategory.undefined] = Icon(Icons.error);
  }

  static Icon getIcon(ApplicationCategory category, bool allApplications) {
    if (_iconsByCategory == null) {
      _makeIcons();
    }

    if (category == null ||  allApplications == null ||  allApplications) return _allApplicationsIcon;

    return _iconsByCategory[category];
  }
}
