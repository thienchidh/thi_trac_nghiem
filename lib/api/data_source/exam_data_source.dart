import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';

/// not using cache
class ExamDataSource extends DataSource<Exam> {
  static final _singleton = ExamDataSource._();

  factory ExamDataSource() => _singleton;

  ExamDataSource._() : super();

  String _lop;

  @override
  Future<List<Exam>> getData({bool isFirstLoading}) async {
    return _fetchNetworkResult();
  }

  @override
  void setParameter({@required List<String> parameter}) {
    assert(parameter.length >= 1);
    _lop = parameter.first;
  }

  String _getPath() {
    return '$baseUrl/apiThitracnghiem/api01/General?doing=getInfo&actionInfo=getListInfoOfLop&lop=$_lop';
  }

  Future<List<Exam>> _fetchNetworkResult() async {
    String path = _getPath();
    try {
      final response = await getUrl('$path');
      final students = ListStudents.fromJson(json.decode(response.body));

      return students.listInfoBaithi;
    } catch (e) {
      print(e);
      throw StateError('$e');
    }
  }
}
