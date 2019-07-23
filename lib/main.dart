import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thi_trac_nghiem/screens/home_screen.dart';
import 'package:thi_trac_nghiem/screens/login_screen.dart';
import 'package:thi_trac_nghiem/screens/search_screen.dart';
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
      title: UIData.APP_NAME,
      theme: ThemeData(
        primarySwatch: UIData.primaryColor,
        accentColor: UIData.accentColor,
        fontFamily: UIData.quickFont,
        buttonColor: UIData.primaryColor,
        buttonTheme: ButtonThemeData(
          buttonColor: UIData.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: LoginScreen(),
      routes: <String, WidgetBuilder>{
        '/${UIData.LOGIN_ROUTE_NAME}': (_) => LoginScreen(),
        '/${UIData.HOME_ROUTE_NAME}': (_) => HomeScreen(),
        '/${UIData.EXAM_ROUTE_NAME}': (_) => HomeScreen(),
        '/${UIData.NOT_FOUND_ROUTE_NAME}': (_) => HomeScreen(),
        '/${UIData.PRACTICE_ROUTE_NAME}': (_) => SearchScreen(),
        '/${UIData.HISTORY_ROUTE_NAME}': (_) => HomeScreen(),
        '/${UIData.SUPPORT_ROUTE_NAME}': (_) => HomeScreen(),
        '/${UIData.SETTINGS_EXAM_ROUTE_NAME}': (_) => HomeScreen(),
        '/${UIData.ABOUT_US_ROUTE_NAME}': (_) => HomeScreen(),
        '/${UIData.ADVANCE_ROUTE_NAME}': (_) => HomeScreen(),
      },
      onUnknownRoute: (RouteSettings rs) {
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
      },
    );
  }
}
