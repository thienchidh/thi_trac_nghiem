import 'dart:collection';
import 'dart:convert';

import 'package:thi_trac_nghiem/api/config_api.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';

class FavoriteDataSource extends DataSource<Question> {
  static final _singleton = FavoriteDataSource._();

  final Map<String, ListQuestions> _cacheList;

  factory FavoriteDataSource() => _singleton;

  FavoriteDataSource._()
      : _cacheList = HashMap<String, ListQuestions>(),
        super();

  String _startId;
  String _studentCode;

  @override
  Future<List<Question>> getData(
      {Map<String, dynamic> parameter, bool isFirstLoading}) async {
    String key = makeKeyCacheList([_studentCode, _startId]);
    if (_cacheList.containsKey(key)) {
      final cacheResult = _fetchCacheResult(key);
      return cacheResult != null ? cacheResult : _fetchNetworkResult();
    }
    return _fetchNetworkResult();
  }

  @override
  void setParameter({List<String> parameter}) {
    assert(parameter.length >= 1);
    _studentCode = parameter.first;
    _startId = '0';
  }

  Future<List<Question>> _fetchCacheResult(String key) async {
    ListQuestions listQuestions = _cacheList[key];
    _startId = listQuestions.nextId;
    return listQuestions.listData;
  }

  String _getPath() {
    return '$baseUrl/apiThitracnghiem/api01/General?doing=getInfo&actionInfo=getFavourite&mssv=$_studentCode&startId=$_startId';
  }

  Future<List<Question>> _fetchNetworkResult() async {
    String path = _getPath();
    try {
      final response = await getUrl('$path');
      final questions = ListQuestions.fromJson(json.decode(response.body));

      String key = makeKeyCacheList([_studentCode, _startId]);
      _cacheList[key] = questions;

      final list = questions.listData;

      for (int i = 0; i < list.length; i++) {
        final id = list[i].id;

        if (haveCache(id)) {
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
