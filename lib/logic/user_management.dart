import 'package:thi_trac_nghiem/api/post/login_api.dart';
import 'package:thi_trac_nghiem/model/api_model/account.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';

class UserManagement {
  static final UserManagement _singleton = UserManagement._();

  factory UserManagement() => _singleton;

  UserManagement._(); // private constructor

  Exam curExam;

  // for auto login
  bool isAutoLogin = true;
  User _curUser;
  Account _account;

  Account get curAccount => _account;

  User get curUser => _curUser;

  Future<User> login(Account account) async {
    _account = account;
    _curUser = await LoginApi().verifyLogin(account);
    return _curUser;
  }
}
