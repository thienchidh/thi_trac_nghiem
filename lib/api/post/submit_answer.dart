import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/model/answer.dart';
import 'package:thi_trac_nghiem/utils/delay_ultis.dart';

class SubmitAnswer {
  static final _singleton = SubmitAnswer._();

  SubmitAnswer._();

  factory SubmitAnswer() => _singleton;

  final Client _client = Client();

  Future<bool> submitAnswer(StudentAnswer answer,
      {bool isOnlySave = false}) async {
    try {
      DelayUltis ultis = DelayUltis(milliseconds: DEFAULT_MILLIS_SLEEP_API);
      ultis.start();

      final url = '$baseUrl/$apiName/api03/SinhVien/postDapAn_Bailam';

      final response = await _client
          .post(url,
              body: answer.toMap()
                ..addAll({
                  'isSubmited': isOnlySave ? '0' : '1',
                }))
          .timeout(connectTimedOut);

      final results = json.decode(response.body);

      await ultis.finish();

      return results[STATUS] == STATUS_SUCCESS;
    } catch (e) {
      print('$e');
      return false;
    }
  }
}
