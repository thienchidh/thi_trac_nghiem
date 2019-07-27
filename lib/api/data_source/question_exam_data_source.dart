import 'dart:collection';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:thi_trac_nghiem/api/config_api.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/model/api_model/exam_questions.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';

class QuestionExamDataSource extends DataSource<Question> {
  static final _singleton = QuestionExamDataSource._();

  final Map<String, ExamQuestions> _cacheList;

  factory QuestionExamDataSource() => _singleton;

  QuestionExamDataSource._()
      : _cacheList = HashMap<String, ExamQuestions>(),
        super();

  String _studentCode;
  String _examCode;

  @override
  Future<List<Question>> getData({bool isFirstLoading}) async {
    String key = makeKeyCacheList([_studentCode, _examCode]);
    if (_cacheList.containsKey(key)) {
      final cacheResult = _fetchCacheResult(key);
      return cacheResult != null ? cacheResult : _fetchNetworkResult();
    }
    return _fetchNetworkResult();
  }

  @override
  void setParameter({@required List<String> parameter}) {
    assert(parameter.length >= 2);
    _studentCode = parameter.first;
    _examCode = parameter[1];
  }

  Future<List<Question>> _fetchCacheResult(String key) async {
    ExamQuestions listQuestions = _cacheList[key];
    return listQuestions.listCauHoiDetails;
  }

  String _getPath() {
    return '$baseUrl/apiThitracnghiem/api01/General?doing=getInfo&actionInfo=getDethi&mssv=$_studentCode&bai_thi=$_examCode';
  }

  Future<List<Question>> _fetchNetworkResult() async {
    String path = _getPath();
    try {
      final response = await getUrl('$path');
      final questions = ExamQuestions.fromJson(json.decode(response.body));

      String key = makeKeyCacheList([_studentCode, _examCode]);
      _cacheList[key] = questions;

      final list = questions.listCauHoiDetails;

      for (int i = 0; i < list.length; i++) {
        final id = list[i].id;

        if (haveCache(id)) {
          list[i] = getFromCache(id);
        } else {
          putToCache(id, list[i]);
        }
      }

      return list;
    } catch (e) {
      print(e);
      throw StateError('$e');
    }
  }
}
