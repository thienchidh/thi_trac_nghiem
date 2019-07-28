import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thi_trac_nghiem/ui/screens/exam_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/favorite_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/finished_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/home_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/list_class_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/list_title_exam_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/login_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/search_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/setting_exam_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/timer_screen.dart';
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
  void initState() {
    _checkPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        '/${UIData.LIST_EXAM_ROUTE_NAME}': (_) => ListTitleExamScreen(),
        '/${UIData.PRACTICE_ROUTE_NAME}': (_) => SearchScreen(),
        '/${UIData.ADVANCE_ROUTE_NAME}': (_) => TimerScreen(),
        '/${UIData.SETTINGS_EXAM_ROUTE_NAME}': (_) => SettingExamScreen(),
        '/${UIData.FAVORITE_ROUTE_NAME}': (_) => FavoriteScreen(),
        '/${UIData.NOT_FOUND_ROUTE_NAME}': (_) => HomeScreen(),
        '/${UIData.HISTORY_ROUTE_NAME}': (_) => ListClassScreen(),
        '/${UIData.SUPPORT_ROUTE_NAME}': (_) => ListTitleExamScreen(),
        '/${UIData.ABOUT_US_ROUTE_NAME}': (_) => TimerScreen(),
        '/${UIData.FINISHED_ROUTE_NAME}': (_) => FinishedScreen(),
      },
      onUnknownRoute: (RouteSettings rs) {
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: Text('Not found!'),
              ),
            );
          },
        );
      },
    );
  }
}
