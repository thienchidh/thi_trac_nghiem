import 'dart:async';
import 'dart:collection' show UnmodifiableListView;

import 'package:collection/collection.dart' show ListEquality;
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/utils/delay_ultis.dart';

class DataListState<T> {
  final UnmodifiableListView<T> listData;
  final bool isLoading;
  final Object error;

  const DataListState({
    @required this.listData,
    @required this.isLoading,
    @required this.error,
  });

  factory DataListState.initial() {
    return DataListState<T>(
      listData: UnmodifiableListView<T>(<T>[]),
      isLoading: false,
      error: null,
    );
  }

  DataListState<T> copyWith({
    List<T> listData,
    bool isLoading,
    Object error,
  }) =>
      DataListState<T>(
        error: error,
        listData:
            listData != null ? UnmodifiableListView(listData) : this.listData,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DataListState<T> &&
              runtimeType == other.runtimeType &&
              const ListEquality().equals(listData, other.listData) &&
              isLoading == other.isLoading &&
          error == other.error;

  @override
  int get hashCode => listData.hashCode ^ isLoading.hashCode ^ error.hashCode;

  @override
  String toString() {
    return 'DataListState{listData: $listData, isLoading: $isLoading, error: $error}';
  }
}

class DataBloc<T> {
  final IDataSource<T> _dataSource;
  final _loadAllController = PublishSubject<void>();

  final _errorController = BehaviorSubject<Object>.seeded(null, sync: true);
  Stream<Object> _errorNotNull$; // stream of errors exposed to UI
  final _isLoadingFirstPageController =
  BehaviorSubject<bool>.seeded(false, sync: true);
  ValueObservable<bool> _isLoadingFirstPage$;
  final _loadFirstPageController = PublishSubject<void>();

  final _loadMoreController = PublishSubject<void>();

  ValueConnectableObservable<DataListState<T>> _dataList$;
  StreamSubscription<DataListState<T>> _streamSubscription;

  Sink<void> get loadMore => _loadMoreController.sink;

  Sink<void> get loadFirstPage => _loadFirstPageController.sink;

  Stream<DataListState<T>> get dataList => _dataList$;

  Stream<void> get loadedAllData => _loadAllController.stream;

  Stream<Object> get error => _errorNotNull$;

  DataBloc(this._dataSource) : assert(_dataSource != null) {
//    _errorNullable$ = _errorController;
    _errorNotNull$ = _errorController.where((error) => error != null);
    _isLoadingFirstPage$ = _isLoadingFirstPageController.stream;

    final Observable<DataListState<T>> loadMore = _loadMoreController
        .throttleTime(Duration(milliseconds: 50))
        .doOnData((_) => print('_loadMoreController emitted...'))
        .where((_) {
      final isLoadingFirstPage = _isLoadingFirstPage$.value;
//          final error = _errorNullable$.value;
//          return !isLoadingFirstPage && error == null;
      return !isLoadingFirstPage;
    })
        .doOnData((_) => print('Load more emitted...'))
        .map((_) => false)
        .exhaustMap(_loadMoreData)
//        .doOnData((data) => print('after exhaustMap onNext = $data')); // use exhaustMap operator, to ignore all value source emit, while loading data from api,
        ;
    final Observable<DataListState<T>> loadFirstPage = _loadFirstPageController
        .doOnData((_) => print('Load first page emitted...'))
        .map((_) => true)
        .flatMap(_loadMoreData)
//        .doOnData((data) => print('after flatMap onNext = $data'));
        ;
    final Observable<Observable<DataListState<T>>> streams = Observable.merge([
      loadFirstPage,
      loadMore,
    ]).map((state) => Observable.just(state));
    // merger to one stream, and map each state to Observable

    _dataList$ = Observable.switchLatest(streams)
        .distinct()
//        .doOnData((state) => print('state = $state'))
        .publishValueSeeded(DataListState.initial());

    _streamSubscription = _dataList$.connect();
  }

  Future<void> refresh() async {
    print('Refresh start');

    _isLoadingFirstPageController.add(true);
    _loadFirstPageController.add(null);
    await _isLoadingFirstPage$.firstWhere((b) => !b);

    print('Refresh done');
  }

  Stream<DataListState<T>> _loadMoreData(bool loadFirstPage) async* {
    if (loadFirstPage) {
      _isLoadingFirstPageController.add(true);
    }

    // get latest state
    final latestState = _dataList$.value;
//    print(
//      '_loadMoreData loadFirstPage = $loadFirstPage, latestState = $latestState',
//    );

    final currentList = latestState.listData;

    // emit loading state
    yield latestState.copyWith(
        isLoading: true, listData: loadFirstPage ? [] : null);

    DelayUltis ultis = DelayUltis(milliseconds: loadFirstPage ? 250 : 50);
    ultis.start();

    try {
      // fetch page from data source
      final data = await _dataSource.getData(
        isFirstLoading: _isLoadingFirstPage$.value,
      );

      if (data.isEmpty) {
        // if page is empty, emit all paged loaded
        _loadAllController.add(null);
      }

      // if fetch success, emit null
      _errorController.add(null);

      final listData = <T>[];
      if (!loadFirstPage) {
        // if not load first page, append current list
        listData.addAll(currentList);
      }
      listData.addAll(data);

      await ultis.finish();

      // emit list state
      yield latestState.copyWith(
        isLoading: false,
        error: null,
        listData: listData,
      );
    } catch (e) {
      // if error was occurred, emit error
      if (!_errorController.isClosed) {
        _errorController.add(e);

        print('DataBloc._loadMoreData.error = $e');

        yield latestState.copyWith(
          isLoading: false,
          error: e,
        );
      }
    } finally {
      if (loadFirstPage) {
        if (!_isLoadingFirstPageController.isClosed) {
          _isLoadingFirstPageController.add(false);
        }
      }
    }
  }

  Future<void> dispose() {
    return Future.wait([
      _streamSubscription.cancel(),
      _loadAllController.close(),
      _loadMoreController.close(),
      _loadFirstPageController.close(),
      _errorController.close(),
      _isLoadingFirstPageController.close(),
    ]);
  }
}
