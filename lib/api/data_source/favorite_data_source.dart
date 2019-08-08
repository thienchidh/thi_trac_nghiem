import 'dart:convert';

import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';

class FavoriteDataSource extends DataSource<Question> {
  static final _singleton = FavoriteDataSource._();

  factory FavoriteDataSource() => _singleton;

  FavoriteDataSource._() : super();

  String _startId;
  String _studentCode;

  @override
  Future<List<Question>> getData(
      {Map<String, dynamic> parameter, bool isFirstLoading}) async {
    return _fetchNetworkResult();
  }

  @override
  void setParameter({List<String> parameter}) {
    assert(parameter.length >= 1);
    _studentCode = parameter.first;
    _startId = '0';
  }

  String _getPath() {
    return '$baseUrl/apiThitracnghiem/api01/General?doing=getInfo&actionInfo=getFavourite&mssv=$_studentCode&startId=$_startId';
  }

  Future<List<Question>> _fetchNetworkResult() async {
    String path = _getPath();
    try {
      final response = await getUrl('$path');
      final questions = ListQuestions.fromJson(json.decode(response.body));

      final list = questions.listData;

      for (int i = 0; i < list.length; i++) {
        final id = list[i].id;

        if (isContainsCache(id)) {
          list[i] = getFromCache(id);
        } else {
          putToCache(id, list[i]);
        }
      }

      _startId = questions.nextId;
      return list;
    } catch (e) {
      print(e);
      throw StateError('$e');
    }
  }
}
