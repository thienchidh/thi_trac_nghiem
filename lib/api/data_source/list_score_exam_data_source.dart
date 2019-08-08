import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/model/api_model/exam_questions.dart';
import 'package:thi_trac_nghiem/model/api_model/list_exam_questions.dart';

class ListScoreExamDataSource extends DataSource<ExamQuestions> {
  static final _singleton = ListScoreExamDataSource._();

  factory ListScoreExamDataSource() => _singleton;

  ListScoreExamDataSource._() : super();

  String _startId;
  String _examCode;
  String _lop;

  @override
  Future<List<ExamQuestions>> getData({bool isFirstLoading}) async {
    return _fetchNetworkResult();
  }

  @override
  void setParameter({@required List<String> parameter}) {
    assert(parameter.length >= 2);
    _examCode = parameter.first;
    _lop = parameter[1];
    _startId = '0';
  }

  String _getPath() {
    return 'http://103.81.86.156:8080/apiThitracnghiem/api01/General?doing=getInfo&actionInfo=getInfoDethiOfLopBaithi&lop=$_lop&bai_thi=$_examCode&startId=$_startId';
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
