import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/model/api_model/exam_schedule.dart';
import 'package:thi_trac_nghiem/utils/delay_ultis.dart';

class PostExamSchedule {
  static final _singleton = PostExamSchedule._();

  PostExamSchedule._();

  factory PostExamSchedule() => _singleton;

  final Client _client = Client();

  Future<bool> postExamSchedule(ExamSchedule examSchedule) async {
    try {
      DelayUltis ultis = DelayUltis(milliseconds: DEFAULT_MILLIS_SLEEP_API);
      ultis.start();

      final url =
          '$baseUrl/apiThitracnghiem/api02/GiangVien/postLichThi_Lop_BaiThi';

      final response = await _client
          .post(url, body: examSchedule.toMap())
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
