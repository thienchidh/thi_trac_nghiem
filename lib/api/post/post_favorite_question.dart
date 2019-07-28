import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/model/api_model/favorite.dart';
import 'package:thi_trac_nghiem/utils/delay_ultis.dart';

class PostFavoriteQuestion {
  static final _singleton = PostFavoriteQuestion._();

  PostFavoriteQuestion._();

  factory PostFavoriteQuestion() => _singleton;

  final Client _client = Client();

  Future<bool> postExamSchedule(Favorite favoriteItem) async {
    try {
      DelayUltis ultis = DelayUltis(milliseconds: DEFAULT_MILLIS_SLEEP_API);
      ultis.start();

      final url = '$baseUrl/apiThitracnghiem/api03/SinhVien/postFavourite';

      final response = await _client
          .post(url, body: favoriteItem.toMap())
          .timeout(connectTimedOut);

      final results = json.decode(response.body);

      await ultis.finish();

      return results['status'].toString().toLowerCase() ==
          STATUS_SUCCESS.toLowerCase();
    } catch (e) {
      print('$e');
      return false;
    }
  }
}
