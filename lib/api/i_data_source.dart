import 'package:meta/meta.dart';

abstract class IDataSource<T> {
  Future<List<T>> getData({
    @required String keyWord,
    bool isFirstLoading,
  });
}
