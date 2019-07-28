import 'dart:collection';

import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';

abstract class IDataSource<T> {
  Future<List<T>> getData({
    bool isFirstLoading,
  });

  void setParameter({
    @required List<String> parameter,
  });
}

abstract class DataSource<T> implements IDataSource<T> {
  final Client _client;
  final Map<String, T> _cache;

  DataSource()
      : _cache = HashMap<String, T>(),
        _client = Client();

  Future<Response> getUrl(String url, {Map<String, String> arguments}) {
    return _client.get(url).timeout(connectTimedOut);
  }

  Future<Response> postUrl(String url, {Map<String, String> arguments}) {
    return _client.post(url).timeout(connectTimedOut);
  }

  /// insert or update value
  void putToCache(String key, T value) {
    _cache[key] = value;
  }

  /// can be null
  T getFromCache(String key) {
    return _cache[key];
  }

  bool isContainsCache(String key) {
    return _cache.containsKey(key);
  }
}

/// start functions area
String makeKeyCacheList(List<String> list) {
  StringBuffer sb = StringBuffer();
  sb.writeAll(list, '+-*/');
  return sb.toString();
}

/// end functions area
