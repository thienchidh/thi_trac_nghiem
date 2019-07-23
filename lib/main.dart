import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thi_trac_nghiem/screens/home_screen.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  StatelessElement createElement() {
    _checkPermissions();
    return super.createElement();
  }

  Future<void> _checkPermissions() async {
    var permissions = [PermissionGroup.microphone];

    var permissionHandler = PermissionHandler();

    await permissionHandler.requestPermissions(permissions);

    var status = await permissionHandler
        .checkPermissionStatus(PermissionGroup.microphone);

    if (status.value != PermissionStatus.granted.value) {
      print("PermissionStatus[value] != granted");
      exit(-1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      title: UIData.appName,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.pink,
        fontFamily: UIData.quickFont,
        buttonColor: Colors.pink,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
//      home: LoginScreen(),
      home: HomeScreen(),
    );
  }
}
