import 'dart:async';
import 'dart:collection' show UnmodifiableListView;
import 'dart:math';

import 'package:collection/collection.dart' show ListEquality;
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thi_trac_nghiem/api/question_data_source.dart';
import 'package:thi_trac_nghiem/model/list_questions.dart';

///
///
///

@immutable
class QuestionListState {
  final UnmodifiableListView<Question> question;
  final bool isLoading;
  final Object error;

  const QuestionListState({
    @required this.question,
    @required this.isLoading,
    @required this.error,
  });

  factory QuestionListState.initial() => QuestionListState(
        isLoading: false,
        question: UnmodifiableListView(<Question>[]),
        error: null,
      );

  QuestionListState copyWith({
    List<Question> question,
    bool isLoading,
    Object error,
  }) =>
      QuestionListState(
        error: error,
        question:
            question != null ? UnmodifiableListView(question) : this.question,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionListState &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(question, other.question) &&
          isLoading == other.isLoading &&
          error == other.error;

  @override
  int get hashCode => question.hashCode ^ isLoading.hashCode ^ error.hashCode;

  @override
  String toString() =>
      'QuestionListState(question.length=${question.length}, isLoading=$isLoading, error=$error)';
}

///
///
///

class QuestionBloc {
  final IQuestionDataSource _questionDataSource;

  ///
  /// PublishSubject emit object when reach max items
  ///
  final _loadAllController = PublishSubject<void>();

  ///
  /// BehaviorSubject of errors, emit null when have no error
  ///
  final _errorController = BehaviorSubject<Object>(seedValue: null, sync: true);

//  ValueObservable<Object> _errorNullable$;
  Stream<Object> _errorNotNull$; // stream of errors exposed to UI

  ///
  /// BehaviorSubject and Stream handle first page is loading
  ///
  final _isLoadingFirstPageController =
      BehaviorSubject<bool>(seedValue: false, sync: true);
  ValueObservable<bool> _isLoadingFirstPage$;

  ///
  /// PublishSubject handle load first page intent
  ///
  final _loadFirstPageController = PublishSubject<void>();

  ///
  /// PublishSubject handle load more intent
  ///
  final _loadMoreController = PublishSubject<void>();

  ///
  /// Stream of states
  ///
  ValueConnectableObservable<QuestionListState> _questionList$;
  StreamSubscription<QuestionListState> _streamSubscription;

  String _keyWord;

  String get keyWord => _keyWord;

  set keyWord(String value) => _keyWord = value;

  ///
  /// Sinks
  ///
  Sink<void> get loadMore => _loadMoreController.sink;

  Sink<void> get loadFirstPage => _loadFirstPageController.sink;

  ///
  /// Streams
  ///
  Stream<QuestionListState> get questionList => _questionList$;

  Stream<void> get loadedAllQuestion => _loadAllController.stream;

  Stream<Object> get error => _errorNotNull$;

  QuestionBloc(this._questionDataSource) : assert(_questionDataSource != null) {
//    _errorNullable$ = _errorController;
    _errorNotNull$ = _errorController.where((error) => error != null);
    _isLoadingFirstPage$ = _isLoadingFirstPageController.stream;

    final Observable<QuestionListState> loadMore = _loadMoreController
        .throttle(Duration(milliseconds: 50))
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
        .doOnData(
          (data) => print('after exhaustMap onNext = $data'),
        ); // use exhaustMap operator, to ignore all value source emit, while loading data from api,

    final Observable<QuestionListState> loadFirstPage = _loadFirstPageController
        .doOnData((_) => print('Load first page emitted...'))
        .map((_) => true)
        .flatMap(_loadMoreData)
        .doOnData((data) => print('after flatMap onNext = $data'));

    final Observable<Observable<QuestionListState>> streams = Observable.merge([
      loadFirstPage,
      loadMore,
    ]).map((state) => Observable.just(state));
    // merger to one stream, and map each state to Observable

    _questionList$ = Observable.switchLatest(streams)
        .distinct()
        .doOnData((state) => print('state = $state'))
        .publishValue(seedValue: QuestionListState.initial());

    _streamSubscription = _questionList$.connect();
  }

  Future<void> refresh() async {
    print('Refresh start');

    _isLoadingFirstPageController.add(true);
    _loadFirstPageController.add(null);
    await _isLoadingFirstPage$.firstWhere((b) => !b);

    print('Refresh done');
  }

  Stream<QuestionListState> _loadMoreData(bool loadFirstPage) async* {
    if (loadFirstPage) {
      _isLoadingFirstPageController.add(true);
    }

    // get latest state
    final latestState = _questionList$.value;
    print(
      '_loadMoreData loadFirstPage = $loadFirstPage, latestState = $latestState',
    );

    final currentList = latestState.question;

    // emit loading state
    yield latestState.copyWith(
        isLoading: true, question: loadFirstPage ? [] : null);

    final int oldTime = DateTime.now().millisecondsSinceEpoch;

    try {
      // fetch page from data source
      final questions = await _questionDataSource.getQuestions(
        keyWord: _keyWord,
        isFirstLoading: _isLoadingFirstPage$.value,
      );

      if (questions.isEmpty) {
        // if page is empty, emit all paged loaded
        _loadAllController.add(null);
      }

      // if fetch success, emit null
      _errorController.add(null);

      final question = <Question>[];
      if (!loadFirstPage) {
        // if not load first page, append current list
        question.addAll(currentList);
      }
      question.addAll(questions);

      final int newTime = DateTime.now().millisecondsSinceEpoch;

      await Future.delayed(
        Duration(
          milliseconds: max(0, newTime - oldTime + 100),
        ),
      );

      // emit list state
      yield latestState.copyWith(
        isLoading: false,
        error: null,
        question: question,
      );
    } catch (e) {
      // if error was occurred, emit error
      _errorController.add(e);

      yield latestState.copyWith(
        isLoading: false,
        error: e,
      );
    } finally {
      if (loadFirstPage) {
        _isLoadingFirstPageController.add(false);
      }
    }
  }

  Future<void> dispose() => Future.wait([
        _streamSubscription.cancel(),
        _loadAllController.close(),
        _loadMoreController.close(),
        _loadFirstPageController.close(),
        _errorController.close(),
        _isLoadingFirstPageController.close(),
      ]);
}
