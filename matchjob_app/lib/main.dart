import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:matchjob/login.dart';
import 'package:matchjob/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(title: "Match Job", home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return new WillPopScope(
        onWillPop: () async => false,
        child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '',
          theme: new ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: new Splash(),
        ));
  }
}
