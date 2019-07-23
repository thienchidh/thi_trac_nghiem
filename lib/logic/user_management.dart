import 'package:thi_trac_nghiem/api/login_api.dart';
import 'package:thi_trac_nghiem/model/account.dart';

class UserManagement {
  static final UserManagement _singleton = UserManagement._();

  factory UserManagement() => _singleton;

  UserManagement._(); // private constructor

  bool isUserLogout = false;
  User _curUser;

  User get curUser => _curUser;

  Future<User> login(Account a) async {
    _curUser = await LoginApi().verifyLogin(a);
    return _curUser;
  }
}
