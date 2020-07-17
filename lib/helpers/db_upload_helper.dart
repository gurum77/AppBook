// comments를 upload 한다.
import 'dart:async';
import 'dart:convert';

import 'package:appbook/data/comment_data.dart';
import 'package:appbook/data/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_storage/firebase_storage.dart';

import "db_core_helper.dart";
import 'db_get_helper.dart';

// 변경되는 만큼의 like 또는 unlike를 upload한다.
void uploadLikeOrUnlikeAdded(String email, bool like) {
  var doc = getUserDetailDocumentByEmail(email);

  String fieldName = like ? 'like' : 'unlike';

  doc.get().then((value) async {
    // 아직 없으면 하나 만든다.
    if (value.data == null) {
      Map<String, dynamic> data = {
        'like': 0,
        'unlike': 0,
      };

      await doc.setData(data);
    }

    int current = value.data[fieldName];
    doc.updateData({fieldName: current + 1});
  });
}

// 변경된 comment data를 upload한다.
void uploadChangedComment(String packageName, CommentData commentData) {
  var doc = getAppDetailDocumentByPackageName(packageName);
  doc.get().then((value) {
    List<dynamic> comments = value.data['comments'];
    for (int i = 0; i < comments.length; ++i) {
      var comment = comments[i];

      var json;
      try {
        json = jsonDecode(comment);
      } catch (e) {
        var tmp = CommentData.fromString(comment);
        json = tmp.toJson();
      }

      if (json['id'] == commentData.id) {
        // comment 교체
        json = commentData.toJson();
        comment = jsonEncode(json);

        comments[i] = comment;
        doc.updateData({'comments': comments});
        break;
      }
    }
  });
}

// 새로운 comment를 upload 한다.
Future<void> uploadNewComment(Application app, String newComment) async {
  var doc = getAppDetailDocumentByPackageName(app.packageName);

  Map<String, dynamic> data = {
    'app_name': app.appName,
    'category': app.category == null ? -1 : app.category.index,
    'install_time': app.installTimeMillis,
    'version_name': app.versionName,
    'comments': 'array-contains',
  };

  if (app is ApplicationWithIcon) {
    data['app_icon'] = base64Encode(app.icon);
  }
  CommentData commentData =
      CommentData(newComment, StaticData.currentEmail, 0, 0);
  String commentDataString = jsonEncode(commentData.toJson());
  var value = await getAppComments(StaticData.currentApplication.packageName);
  value.add(commentDataString);

  doc.setData(data);
  await doc.updateData({'comments': FieldValue.arrayUnion(value)});
}

// icon을 upload한다.
// ignore: unused_element
Future<void> _uploadIcon(Application app) async {
  if (app is ApplicationWithIcon) {
    var rootRef = FirebaseStorage.instance.ref().getRoot();
    var appIconsRef = rootRef.child('app_icons');
    var iconRef = appIconsRef.child(app.packageName);
    final StorageUploadTask uploadTask = iconRef.putData(app.icon);
    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      print('EVENT ${event.type}');
    });

    await uploadTask.onComplete;
    streamSubscription.cancel();
  }
}
