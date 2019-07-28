import 'dart:convert';

import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/model/api_model/list_my_class.dart';

/// no load more
class ClassDataSource extends DataSource<String> {
  static final _singleton = ClassDataSource._();

  factory ClassDataSource() => _singleton;

  ClassDataSource._() : super();

  @override
  Future<List<String>> getData(
      {Map<String, dynamic> parameter, bool isFirstLoading}) async {
    return _fetchNetworkResult();
  }

  @deprecated
  @override
  void setParameter({List<String> parameter}) {
    // nothing here
  }

  String _getPath() {
    return '$baseUrl/apiThitracnghiem/api01/General?doing=getInfo&actionInfo=getDSLop';
  }

  Future<List<String>> _fetchNetworkResult() async {
    String path = _getPath();
    try {
      final response = await getUrl('$path');
      final listClass = ListClass.fromJson(json.decode(response.body));

      return listClass.listData;
    } catch (e) {
      print(e);
      throw StateError('$e');
    }
  }
}
