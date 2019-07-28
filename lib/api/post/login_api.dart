import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/model/api_model/account.dart';

class LoginApi {
  static final _singleton = LoginApi._();

  LoginApi._();

  factory LoginApi() => _singleton;

  final Client _client = Client();

  Future<User> verifyLogin(Account account) async {
    try {
      final url = '$baseUrl/apiThitracnghiem/api01/General/getAuthen';

      final response = await _client
          .post(url, body: account.toMap())
          .timeout(connectTimedOut);

      final results = json.decode(response.body);

      User user = User.fromJson(results);
      if (user.status != STATUS_SUCCESS ||
          (!account.isStudent ^ (user.role == 'giangvien'))) {
        return null;
      }

      return user;
    } catch (e) {
      print('$e');
      return null;
    }
  }
}
