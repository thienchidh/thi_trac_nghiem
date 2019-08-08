import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/api/data_source/question_data_source.dart';
import 'package:thi_trac_nghiem/api/post/login_api.dart';
import 'package:thi_trac_nghiem/model/api_model/account.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class UserManagement {
  static final UserManagement _singleton = UserManagement._();

  factory UserManagement() => _singleton;

  UserManagement._(); // private constructor

  String curTeacherCode;

  Exam curExamDoing;

  List<Student> listStudents;

  Map<dynamic, dynamic> map = HashMap<dynamic, dynamic>();

  // for auto login
  bool isAutoLogin = true;
  User curUser;
  Account _account;

  Account get curAccount => _account;

  Future<User> login(Account account) async {
    _account = account;
    curUser = await LoginApi().verifyLogin(account);
    if (curUser?.userType == UserType.teacher) {
      curTeacherCode = curUser.maso;
    }
    return curUser;
  }

  Future<void> logout(BuildContext context, [bool isAutoLogin = false]) async {
    UserManagement().isAutoLogin = isAutoLogin;
    UserManagement().curExamDoing = null;
    QuestionDataSource().cleanup();

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/${UIData.LOGIN_ROUTE_NAME}',
          (_) => false,
    );
  }
}
