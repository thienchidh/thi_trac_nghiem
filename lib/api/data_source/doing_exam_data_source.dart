import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/model/api_model/exam_questions.dart';

class DoingExamDataSource extends DataSource<ExamQuestions> {
  static final _singleton = DoingExamDataSource._();

  factory DoingExamDataSource() => _singleton;

  DoingExamDataSource._() : super();

  String _studentCode;
  String _examCode;

  @override
  Future<List<ExamQuestions>> getData({bool isFirstLoading}) async {
    return _fetchNetworkResult();
  }

  @override
  void setParameter({@required List<String> parameter}) {
    assert(parameter.length >= 2);
    _examCode = parameter.first;
    _studentCode = parameter[1];
  }

  String _getPath() {
    return '$baseUrl/apiThitracnghiem/api01/General?doing=getInfo&actionInfo=getDethi&mssv=$_studentCode&bai_thi=$_examCode';
  }

  Future<List<ExamQuestions>> _fetchNetworkResult() async {
    String path = _getPath();
    try {
      final response = await getUrl('$path');
      final questions = ExamQuestions.fromJson(json.decode(response.body));

      return [questions];
    } catch (e) {
      print(e);
      throw StateError('$e');
    }
  }
}
