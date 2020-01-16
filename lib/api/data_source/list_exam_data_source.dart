import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/model/api_model/exam_questions.dart';
import 'package:thi_trac_nghiem/model/api_model/list_exam_questions.dart';

class ListExamDataSource extends DataSource<ExamQuestions> {
  static final _singleton = ListExamDataSource._();

  factory ListExamDataSource() => _singleton;

  ListExamDataSource._() : super();

  String _startId;
  String _studentCode;

  @override
  Future<List<ExamQuestions>> getData({bool isFirstLoading}) async {
    return _fetchNetworkResult();
  }

  @override
  void setParameter({@required List<String> parameter}) {
    assert(parameter.length >= 1);
    _studentCode = parameter.first;
    _startId = '0';
  }

  String _getPath() {
    return '$baseUrl/$apiName/api01/General?doing=getInfo&actionInfo=getInfoDethiOfMSSVBaithi&mssv=$_studentCode&startId=$_startId';
  }

  Future<List<ExamQuestions>> _fetchNetworkResult() async {
    String path = _getPath();
    try {
      final response = await getUrl('$path');
      final listExamQuestions =
          ListExamQuestions.fromJson(json.decode(response.body));

      _startId = listExamQuestions.nextId;
      return listExamQuestions.listData;
    } catch (e) {
      print(e);
      throw StateError('$e');
    }
  }
}
