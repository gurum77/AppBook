import 'package:appbook/HomePage.dart';
import 'package:appbook/MyAppsPage.dart';
import 'package:flutter/material.dart';

import 'LoginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppBook',
      theme: ThemeData(
    
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DefaultTabController(
        length:3,
        child:Scaffold(
            appBar: AppBar(
              title: Text('AppBook'),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: 'Home',
                    icon: Icon(Icons.home),
                  ),
                  Tab(text: 'My Apps', icon: Icon(Icons.apps)),
                  Tab(text: 'Login', icon:Icon(Icons.bookmark),)
                ],
              ),
            ),
            body: TabBarView(children: <Widget>[
              HomePage(),
              MyAppsPage(),
              LoginPage()
            ],)
            )
      )
    );
  }
}
