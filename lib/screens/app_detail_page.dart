import 'dart:async';
import 'dart:convert';
import 'package:appbook/data/comment_data.dart';
import 'package:appbook/helpers/db_helper.dart';
import 'package:appbook/widgets/app_simple_info.dart';
import 'package:appbook/widgets/comment_list_tile.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appbook/helpers/get_app_detail.dart';

class AppDetailPage extends StatefulWidget {
  @override
  _AppDetailPageState createState() => _AppDetailPageState();
}

class _AppDetailPageState extends State<AppDetailPage> {
  final db = Firestore.instance;

  final commentsTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (StaticData.currentApplication == null) {
      return Scaffold(
        body: Center(
          child: Text('None application'),
        ),
      );
    } else {
      Application app = StaticData.currentApplication;

      return Scaffold(
        appBar: AppBar(title: Text('AppBook')),
        body: Column(
          children: <Widget>[
            Material(
              elevation: 5,
              child: Container(
                child: Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: app is ApplicationWithIcon
                          ? MemoryImage(app.icon)
                          : AssetImage('assets/login.gif'),
                      backgroundColor: Colors.white,
                      radius: 35,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '${app.appName}',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${app.packageName}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                    child: AppSimpleInfo(
                      app: app,
                    ),
                  ),
                ]),
              ),
            ),
            // comments list
            buildCommentsList(),
            // comment 입력창
            buildInputComment(app),
          ],
        ),
      );
    }
  }

  FutureBuilder<List<String>> buildCommentsList() {
    return FutureBuilder(
      future: getAppComments(StaticData.currentApplication.packageName),
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
                  return CommentListTile(position: position, comment: comment);
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
        icon: Icon(Icons.comment),
        suffixIcon: FlatButton(
          padding: EdgeInsets.all(5),
          child: Text('등록'),
          color: Colors.blueAccent,
          onPressed: () async {
            // 유효성 검사
            String comment = commentsTextController.text;
            commentsTextController.text = '';
            if (comment == null || comment.isEmpty) return;
            // icon upload
            //  _uploadIcon(app);

            // upload comments
            await uploadNewComment(app, comment);
            setState(() {
              FocusScope.of(context).unfocus();
            });
          },
        ),
      ),
    );
  }
}
