import 'dart:collection';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';

class StudentDataSource extends DataSource<Student> {
  static final _singleton = StudentDataSource._();

  final Map<String, ListStudents> _cacheList;

  factory StudentDataSource() => _singleton;

  StudentDataSource._()
      : _cacheList = HashMap<String, ListStudents>(),
        super();

  String _lop;

  @override
  Future<List<Student>> getData({bool isFirstLoading}) async {
    String key = makeKeyCacheList([_lop]);
    if (_cacheList.containsKey(key)) {
      final cacheResult = _fetchCacheResult(key);
      return cacheResult != null ? cacheResult : _fetchNetworkResult();
    }
    return _fetchNetworkResult();
  }

  @override
  void setParameter({@required List<String> parameter}) {
    assert(parameter.length >= 1);
    _lop = parameter.first;
  }

  Future<List<Student>> _fetchCacheResult(String key) async {
    final data = _cacheList[key];
    return data.listInfoSinhvien;
  }

  String _getPath() {
    return '$baseUrl/apiThitracnghiem/api01/General?doing=getInfo&actionInfo=getListInfoOfLop&lop=$_lop';
  }

  Future<List<Student>> _fetchNetworkResult() async {
    String path = _getPath();
    try {
      final response = await getUrl('$path');
      final students = ListStudents.fromJson(json.decode(response.body));

      String key = makeKeyCacheList([_lop]);
      _cacheList[key] = students;

      final list = students.listInfoSinhvien;

      for (int i = 0; i < list.length; i++) {
        final id = list[i].maso;

        if (isContainsCache(id)) {
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
