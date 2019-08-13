import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
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
import 'package:thi_trac_nghiem/ui/screens/support_screen.dart';
import 'package:thi_trac_nghiem/ui/screens/timer_screen.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

void main() {
  Admob.initialize(getAppId());
  runApp(MyApp());
}

String getAppId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-6815271897149213~5567088110';
  } else if (Platform.isIOS) {
    return null;
  }
  return null;
}

String getBannerAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-6815271897149213/6497026400';
  } else if (Platform.isIOS) {
    return null;
  }
  return null;
}

class MyApp extends StatelessWidget {
  final materialApp = MaterialApp(
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
      '/${UIData.LIST_EXAM_STUDENT_ROUTE_NAME}': (_) => ListExamScreenForView(),
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
      '/${UIData.SUPPORT_ROUTE_NAME}': (_) => SupportScreen(),
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

  @override
  Widget build(BuildContext context) {
    return materialApp;
  }
}
