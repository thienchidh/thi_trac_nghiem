import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thi_trac_nghiem/screens/exam_screen.dart';
import 'package:thi_trac_nghiem/screens/finished_screen.dart';
import 'package:thi_trac_nghiem/screens/home_screen.dart';
import 'package:thi_trac_nghiem/screens/login_screen.dart';
import 'package:thi_trac_nghiem/screens/search_screen.dart';
import 'package:thi_trac_nghiem/screens/timer_screen.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _checkPermissions() async {
    final permissions = [PermissionGroup.microphone];
    final permissionHandler = PermissionHandler();

    Map<PermissionGroup, PermissionStatus> map =
    await permissionHandler.requestPermissions(permissions);

    map.forEach(
          (request, status) async {
        if (status.value != PermissionStatus.granted.value) {
          print("PermissionStatus[value] != granted");
          print("exit app!");
          SystemChannels.platform
              .invokeMethod('SystemNavigator.pop'); // exit app
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _checkPermissions();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      title: UIData.APP_NAME,
      theme: ThemeData(
        primaryColor: UIData.primaryColor,
        primarySwatch: UIData.primarySwatch,
        accentColor: UIData.accentColor,
        fontFamily: UIData.fontFamily,
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
        '/${UIData.EXAM_ROUTE_NAME}': (_) => ExamScreen(),
        '/${UIData.NOT_FOUND_ROUTE_NAME}': (_) => HomeScreen(),
        '/${UIData.PRACTICE_ROUTE_NAME}': (_) => SearchScreen(),
        '/${UIData.HISTORY_ROUTE_NAME}': (_) => HomeScreen(),
        '/${UIData.SUPPORT_ROUTE_NAME}': (_) => HomeScreen(),
        '/${UIData.SETTINGS_EXAM_ROUTE_NAME}': (_) => TimerScreen(),
        '/${UIData.ABOUT_US_ROUTE_NAME}': (_) => HomeScreen(),
        '/${UIData.ADVANCE_ROUTE_NAME}': (_) => HomeScreen(),
        FinishedScreen.nameRouter: (_) => FinishedScreen(),
      },
      onUnknownRoute: (RouteSettings rs) {
        return MaterialPageRoute(
          builder: (context) {
            return Container();
          },
        );
      },
    );
  }
}
