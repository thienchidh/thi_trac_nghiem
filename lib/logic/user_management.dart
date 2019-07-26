import 'package:thi_trac_nghiem/api/login_api.dart';
import 'package:thi_trac_nghiem/model/api_model/account.dart';

class UserManagement {
  static final UserManagement _singleton = UserManagement._();

  factory UserManagement() => _singleton;

  UserManagement._(); // private constructor

  // for auto login
  bool isAutoLogin = true;
  User _curUser;

  User get curUser => _curUser;

  Future<User> login(Account a) async {
    _curUser = await LoginApi().verifyLogin(a);
    return _curUser;
  }
}
