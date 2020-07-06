import 'package:device_apps/device_apps.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

Future<String> _getIconImageUrl() async {
  var url = 'https://play.google.com/store/apps/details?id=mobile.Byung.Cargo';
  var re = http.read(url);

  re.then((value) {
    var regex = RegExp(r'[\"]https://lh3.googleusercontent.com.*?[\"]');
    var match = regex.firstMatch(value);
    if (match != null) {
      String str = value.substring(match.start, match.end);
      return str;
    } else {
      return 'https://lh3.googleusercontent.com/bklJDdaWKb3pkVJJvwxjNIpMeo2ZnLVzh5I9FMhsNx7P2B-eKgzPXgyRY9XM6kw0ouU=s180-rw';
    }
  });

  return null;
}

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
      //

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
              buildCommentsList(),
              buildInputComments(app),
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

  TextField buildInputComments(Application app) {
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
            // upload icon

            // upload comments
            var collection = db.collection('app_detail');
            var doc = collection.document(app.packageName);

            String imageUrl = 'none';
            var url =
                'https://play.google.com/store/apps/details?id=mobile.Byung.Cargo';
            http.read(url).then((value) {
              var regex =
                  RegExp(r'[\"]https://lh3.googleusercontent.com.*?[\"]');
              var match = regex.firstMatch(value);
              if (match != null) {
                imageUrl = value.substring(match.start, match.end);
                if (imageUrl.length > 2) {
                  String tmp = imageUrl.substring(1, imageUrl.length - 1);
                  imageUrl = tmp;
                }
              }

              getAppComments().then((value) => {
                    doc.setData({
                      'category':
                          app.category == null ? -1 : app.category.index,
                      'install_time': app.installTimeMillis,
                      'version_name': app.versionName,
                      'comments': 'array-contains',
                      'icon_url': imageUrl
                    }),
                    value.add(commentsTextController.text),
                    doc.updateData({'comments': FieldValue.arrayUnion(value)}),
                    commentsTextController.text = ''
                  });
            });
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
}
