import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:thi_trac_nghiem/api/question_data_source.dart';
import 'package:thi_trac_nghiem/model/list_questions.dart';

///
/// An implementation of [IQuestionDataSource], used to test when having no internet connection
///

class QuestionDataSource implements IQuestionDataSource {
  final Client _client;
  final Map<String, ListQuestions> _cache;
  final baseUrl = 'http://103.81.86.156:8080';

  QuestionDataSource()
      : _client = Client(),
        _cache = HashMap(),
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

    String key = _makeKeyCache(_keyWord, _startId);
    if (_cache.containsKey(key)) {
      return _fetchCacheResult(key);
    }
    return _fetchNetworkResult();
  }

  Future<List<Question>> _fetchCacheResult(key) async {
    ListQuestions listQuestions = _cache[key];
    _startId = listQuestions.nextId;
    return listQuestions.listData;
  }

  Future<List<Question>> _fetchNetworkResult() {
    final path =
        '$baseUrl/apiThitracnghiem/api01/General?doing=$_doing&startId=$_startId&key=$_keyWord';

    final Future<List<Question>> data = _client.get('$path').then((response) {
      try {
        final listQuestions =
            ListQuestions.fromJson(json.decode(response.body));

        String key = _makeKeyCache(_keyWord, _startId);
        _cache[key] = listQuestions;

        _startId = listQuestions.nextId;
        return listQuestions.listData;
      } catch (e) {
        print(e);
        throw StateError('$e');
      }
    });

    return data;
  }
}
