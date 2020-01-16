import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/model/api_model/exam_questions.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';

// not using cache
class QuestionExamDataSource extends DataSource<Question> {
  static final _singleton = QuestionExamDataSource._();

  factory QuestionExamDataSource() => _singleton;

  QuestionExamDataSource._() : super();

  String _studentCode;
  String _examCode;

  @override
  Future<List<Question>> getData({bool isFirstLoading}) async {
    return _fetchNetworkResult();
  }

  @override
  void setParameter({@required List<String> parameter}) {
    assert(parameter.length >= 2);
    _studentCode = parameter.first;
    _examCode = parameter[1];
  }

  String _getPath() {
    return '$baseUrl/$apiName/api01/General?doing=getInfo&actionInfo=getDethi&mssv=$_studentCode&bai_thi=$_examCode';
  }

  Future<List<Question>> _fetchNetworkResult() async {
    String path = _getPath();
    try {
      final response = await getUrl('$path');
      final questions = ExamQuestions.fromJson(json.decode(response.body));

      return questions.listCauHoiDetails;
    } catch (e) {
      print(e);
      throw StateError('$e');
    }
  }
}
