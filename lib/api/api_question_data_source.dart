import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:thi_trac_nghiem/api/question_data_source.dart';
import 'package:thi_trac_nghiem/model/list_questions.dart';

/// An implementation of [IQuestionDataSource]

class QuestionDataSource implements IQuestionDataSource {
  static final _singleton = QuestionDataSource._();

  final _baseUrl = 'http://103.81.86.156:8080';

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

  String _makeKeyCache(String first, String second) {
    return '$first - $second';
  }

  @override
  Future<List<Question>> getQuestions({String keyWord, bool isFirstLoading}) {
    if (isFirstLoading) {
      _updateSearchParameter(keyWord);
    }

    final key = _makeKeyCache(_keyWord, _startId);
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

  Future<List<Question>> _fetchNetworkResult() async {
    final path =
        '$_baseUrl/apiThitracnghiem/api01/General?doing=$_doing&startId=$_startId&key=$_keyWord';
    try {
      final response = await _client.get('$path');
      final questions = ListQuestions.fromJson(json.decode(response.body));

      String key = _makeKeyCache(_keyWord, _startId);
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
