import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:thi_trac_nghiem/api/config_api.dart';
import 'package:thi_trac_nghiem/api/i_data_source.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';

class QuestionDataSource implements IDataSource<Question> {
  static final _singleton = QuestionDataSource._();

  final Client _client;
  final Map<String, ListQuestions> _cacheListQuestion;
  final Map<String, Question> _cacheQuestion;

  factory QuestionDataSource() => _singleton;

  QuestionDataSource._()
      : _client = Client(),
        _cacheListQuestion = HashMap(),
        _cacheQuestion = HashMap(),
        super();

  String _startId;
  String _keyWord;
  final String _doing = 'getListQuestion';

  String get keyWord => _keyWord;

  void _updateSearchParameter(String value) {
    _keyWord = value;
    _startId = '0';
  }

  String _makeKeyCacheList(String first, String second) {
    return '$first - $second';
  }

  @override
  Future<List<Question>> getData({String keyWord, bool isFirstLoading}) {
    if (isFirstLoading) {
      _updateSearchParameter(keyWord);
    }

    final key = _makeKeyCacheList(_keyWord, _startId);
    if (_cacheListQuestion.containsKey(key)) {
      final cacheResult = _fetchCacheResult(key);
      return cacheResult != null ? cacheResult : _fetchNetworkResult();
    }
    return _fetchNetworkResult();
  }

  Future<List<Question>> _fetchCacheResult(key) async {
    ListQuestions listQuestions = _cacheListQuestion[key];
    _startId = listQuestions.nextId;
    return listQuestions.listData;
  }

  String _getPath() {
    return '$baseUrl/apiThitracnghiem/api01/General?doing=$_doing&startId=$_startId&key=$_keyWord';
  }

  Future<List<Question>> _fetchNetworkResult() async {
    String path = _getPath();
    try {
      final response = await _client.get('$path');
      final questions = ListQuestions.fromJson(json.decode(response.body));

      String key = _makeKeyCacheList(_keyWord, _startId);
      _cacheListQuestion[key] = questions;

      final list = questions.listData;

      for (int i = 0; i < list.length; i++) {
        final id = list[i].id;

        if (_cacheQuestion.containsKey(id)) {
          list[i] = _cacheQuestion[id];
        } else {
          _cacheQuestion[id] = list[i];
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
