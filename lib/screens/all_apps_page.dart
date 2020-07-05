import 'package:appbook/data/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import 'app_detail_page.dart';

class AllAppsPage extends StatelessWidget {
  var db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    var collection = db.collection('app_detail');
    return FutureBuilder(
      future: collection.getDocuments(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(itemBuilder: (context, position) {
            QuerySnapshot docSnapshot = snapshot.data;
            if (position < docSnapshot.documents.length) {
              var doc = docSnapshot.documents[position];
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(doc.documentID),
                    // onTap: () => DeviceApps.openApp(app.packageName),
                    onTap: () {
                      StaticData.CurrentApplication = null;

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppDetailPage(),
                          ));
                    },
                  ),
                ],
              );
            }
          });
        }
      },
    );
  }
}
