import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thi_trac_nghiem/ui/screens/about_us_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/check_answers_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/exam_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/favorite_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/finished_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/home_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/list_class_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/list_exam_for_view_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/list_score_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/list_student_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/list_title_exam_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/login_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/search_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/setting_exam_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/timer_screen.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

import 'logic/user_management.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your other channel id',
    'your other channel name',
    'your other channel description');
final iOSPlatformChannelSpecifics = IOSNotificationDetails();
final NotificationDetails platformChannelSpecifics = NotificationDetails(
    androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _checkPermissions();
    super.initState();

    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> onSelectNotification(String payload) async {
    await UserManagement().logout(context, true);

    await flutterLocalNotificationsPlugin.cancel(int.parse(payload));
  }

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
        '/${UIData.LIST_EXAM_STUDENT_ROUTE_NAME}': (_) =>
            ListExamScreenForView(),
        '/${UIData.PRACTICE_ROUTE_NAME}': (_) => SearchScreen(),
        '/${UIData.SETTINGS_EXAM_ROUTE_NAME}': (_) => SettingExamScreen(),
        '/${UIData.FAVORITE_ROUTE_NAME}': (_) => FavoriteScreen(),
        '/${UIData.NOT_FOUND_ROUTE_NAME}': (_) => HomeScreen(),
        '/${UIData.FINISHED_ROUTE_NAME}': (_) => FinishedScreen(),
        '/${UIData.HISTORY_ROUTE_NAME}': (_) => ListExamScreenForView(),
        '/${UIData.LIST_STUDENT_ROUTE_NAME}': (_) => ListStudentScreen(),
        '/${UIData.LIST_SCORE_ROUTE_NAME}': (_) => ListScoreScreen(),
        '/${UIData.TIMER_ROUTE_NAME}': (_) => TimerScreen(),
        '/${UIData.ABOUT_US_ROUTE_NAME}': (_) => AboutUsScreen(),
        '/${UIData.ADVANCE_ROUTE_NAME}': (_) => ListClassScreen(),
        '/${UIData.CHECK_ANSWER_ROUTE_NAME}': (_) => CheckAnswersScreen(),
//        '/${UIData.SUPPORT_ROUTE_NAME}': (_) => ListTitleExamScreen(),
      },
      onUnknownRoute: (RouteSettings rs) {
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: Text('Chức năng này hiện chưa khả dụng!'),
              ),
            );
          },
        );
      },
    );
  }
}
