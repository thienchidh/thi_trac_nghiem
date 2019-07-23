import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:thi_trac_nghiem/model/account.dart';

class LoginApi {
  static final _singleton = LoginApi._();

  LoginApi._();

  factory LoginApi() => _singleton;

  final String _baseUrl = "http://103.81.86.156:8080";
  final Client _client = Client();

  Future<User> verifyLogin(Account a) async {
    try {
      final url = "$_baseUrl/apiThitracnghiem/api01/General/getAuthen";

      final queryParameters = {
        "userName": a.username,
        "pass": a.password,
      };

      final response = await _client
          .post(
        url,
        body: queryParameters,
      )
          .timeout(
        const Duration(
          seconds: 10,
        ),
      );
      final results = json.decode(response.body);

      User user = User.fromJson(results);
      if (user.status != "success" ||
          (!a.isStudent ^ (user.role == "giangvien"))) {
        return null;
      }

      return user;
    } catch (e) {
      print('$e');
      return null;
    }
  }
}
