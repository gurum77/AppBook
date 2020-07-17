import 'package:appbook/data/static_data.dart';
import 'package:appbook/data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'db_core_helper.dart';

// package의 comment를 모두 가져온다.
Future<List<String>> getAppComments(String packageName) {
  var doc = getAppDetailDocumentByPackageName(packageName);
  if (doc == null) return null;

  return doc.get().then((DocumentSnapshot ds) {
    var comments = List<String>();
    if (ds.data != null && ds.data['comments'] != null) {
      for (var comment in ds.data['comments']) {
        comments.add(comment.toString());
      }
    }

    return comments;
  });
}

// user의 정보를 가져온다.
Future<UserData> getUserData(String email) async {
  var doc = getUserDetailDocumentByEmail(email);
  if (doc == null) return null;

  return doc.get().then((value) {
    if (value.data != null) {
      var userData = UserData(email, value.data['like'], value.data['unlike']);
      return userData;
    }
  });
}
