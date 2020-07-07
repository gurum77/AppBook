import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AppDetailPage extends StatelessWidget {
  var db = Firestore.instance;
  var commentsTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (StaticData.CurrentApplication == null) {
      return Scaffold(
        body: Center(
          child: Text('None application'),
        ),
      );
    } else {
      Application app = StaticData.CurrentApplication;

      return Scaffold(
        appBar: AppBar(title: Text('AppBook')),
        body: Center(
          child: Column(
            children: <Widget>[
              app is ApplicationWithIcon
                  ? CircleAvatar(
                      backgroundImage: MemoryImage(app.icon),
                      backgroundColor: Colors.white,
                      radius: 70,
                    )
                  : StaticData.CurrentIconUrl != null
                      ? Image.network(StaticData.CurrentIconUrl)
                      : Text('No icon'),
              Text(
                '${app.appName} (${app.packageName})',
                style: TextStyle(fontSize: 19),
              ),
              Text('Version: ${app.versionName}\n'
                  'Installed: ${DateTime.fromMillisecondsSinceEpoch(app.installTimeMillis).toString()}\n'),
              // comments list
              buildCommentsList(),
              // comment 입력창
              buildInputComment(app),
            ],
          ),
        ),
      );
    }
  }

  FutureBuilder<List<String>> buildCommentsList() {
    return FutureBuilder(
      future: getAppComments(),
      builder: (context, snapShot) {
        if (snapShot == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapShot.connectionState == ConnectionState.done) {
            if (snapShot.hasError) {
              return Text(
                "error : " + snapShot.error.toString(),
                style: TextStyle(color: Colors.blue, fontSize: 30),
              );
            }
            List<String> comments = snapShot.data;
            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, position) {
                  var comment = comments[position];
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: Text(position.toString()),
                        onTap: () {},
                        title: Text(comment),
                        subtitle: Text('sub'),
                      ),
                    ],
                  );
                },
                itemCount: comments.length,
              ),
            );
          } else {
            return Text(
              'no data',
              style: TextStyle(color: Colors.yellow, fontSize: 30),
            );
          }
        }
      },
    );
  }

  TextField buildInputComment(Application app) {
    return TextField(
      maxLength: 100,
      autofocus: false,
      controller: commentsTextController,
      decoration: InputDecoration(
        hintText: 'Enter a message',
        suffixIcon: FlatButton(
          padding: EdgeInsets.all(5),
          child: Text('등록'),
          color: Colors.blueAccent,
          onPressed: () {
            // icon upload
            _uploadIcon(app);

            // upload comments
            _uploadComments(app);
          },
        ),
      ),
    );
  }

  // 현재 앱의 comment를 모두 가져온다.
  Future<List<String>> getAppComments() {
    var collection = db.collection('app_detail');
    var doc = collection.document(StaticData.CurrentApplication.packageName);
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

  // comments를 upload 한다.
  void _uploadComments(Application app) {
    var collection = db.collection('app_detail');
    var doc = collection.document(app.packageName);

    getAppComments().then((value) => {
          doc.setData({
            'app_name' : app.appName,
            'category': app.category == null ? -1 : app.category.index,
            'install_time': app.installTimeMillis,
            'version_name': app.versionName,
            'comments': 'array-contains',
          }),
          value.add(commentsTextController.text),
          doc.updateData({'comments': FieldValue.arrayUnion(value)}),
          commentsTextController.text = ''
        });
  }

  // icon을 upload한다.
  Future<void> _uploadIcon(Application app) async {
    if (app is ApplicationWithIcon) {
      final StorageReference storageReference =
          FirebaseStorage().ref().child('/app_icons/' + app.packageName);
      final StorageUploadTask uploadTask = storageReference.putData(app.icon);
      final StreamSubscription<StorageTaskEvent> streamSubscription =
          uploadTask.events.listen((event) {
        print('EVENT ${event.type}');
      });

      await uploadTask.onComplete;
      streamSubscription.cancel();
    }
  }
}
