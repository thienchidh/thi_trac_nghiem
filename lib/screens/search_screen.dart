import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:synchronized/synchronized.dart';
import 'package:thi_trac_nghiem/api/question_data_source.dart';
import 'package:thi_trac_nghiem/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';
import 'package:thi_trac_nghiem/widget/common_drawer.dart';
import 'package:thi_trac_nghiem/widget/question_item.dart';
import 'package:thi_trac_nghiem/widget/search_bar.dart';
import 'package:toast/toast.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _lock = Lock(reentrant: true);

  final _scrollController = ScrollController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const _offsetVisibleThreshold = 50;

  ///
  /// pass [QuestionDataSource] to [DataBloc]'s constructor
  ///
  DataBloc _bloc;
  StreamSubscription<void> _subscriptionReachMaxItems;
  StreamSubscription<Object> _subscriptionError;
  bool isShowAppbar;

  _SearchScreenState({this.isShowAppbar = true}) {
    _bloc = DataBloc<Question>(QuestionDataSource());

    // listen error, reach max items
    _subscriptionReachMaxItems =
        _bloc.loadedAllQuestion.listen(_onReachMaxItem);
    _subscriptionError = _bloc.error.listen(_onError);

    // add listener to scroll controller
    _scrollController.addListener(_onScroll);
  }

  @override
  void initState() {
    super.initState();

    _search('');
  }

  Future<void> _onScroll() async {
    final offset = _scrollController.offset;
    final position = _scrollController.position;
    final maxScrollExtent = position.maxScrollExtent;

    // if scroll to bottom of list, then load next page
    if (offset + _offsetVisibleThreshold == maxScrollExtent ||
        offset == maxScrollExtent) {
      _loadMore();
    }

    if (position.userScrollDirection == ScrollDirection.reverse) {
      if (isShowAppbar) {
        setState(() => isShowAppbar = false);
      }
    } else if (position.userScrollDirection == ScrollDirection.forward) {
      if (!isShowAppbar) {
        setState(() => isShowAppbar = true);
      }
    }
  }

  void _loadMore() {
    print('_bloc.loadMore.add(null)');
    _bloc.loadMore.add(null);
  }

  Future<void> _search(String keyWord) async {
    await _lock.synchronized(() async {
      _bloc.keyWord = keyWord;
      await _bloc.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: Visibility(
        visible: !isShowAppbar,
        child: FloatingActionButton(
          tooltip: 'Scroll to top',
          mini: true,
          child: Icon(
            Icons.keyboard_arrow_up,
          ),
          onPressed: () {
            _scrollController.animateTo(
              0.0,
              curve: Curves.ease,
              duration: const Duration(milliseconds: 10000),
            );
          },
        ),
      ),
      drawer: CommonDrawer(),
      body: RefreshIndicator(
        child: Container(
          constraints: BoxConstraints.expand(),
          child: StreamBuilder<DataListState>(
            stream: _bloc.questionList,
            builder:
                (BuildContext context, AsyncSnapshot<DataListState> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error ${snapshot.error}'),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              }

              return _buildList(snapshot);
            },
          ),
        ),
        onRefresh: _bloc.refresh,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    Future.wait([
      _bloc.dispose(),
      _subscriptionError.cancel(),
      _subscriptionReachMaxItems.cancel(),
    ]);

    super.dispose();
  }

  Widget _buildList(AsyncSnapshot<DataListState> snapshot) {
    final data = snapshot.data.listData;
    final isLoading = snapshot.data.isLoading;
    final error = snapshot.data.error;

    return CustomScrollView(
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          title: SearchBar(
            performSearch: _search,
            performOpenDrawer: () {
              final currentState = _scaffoldKey.currentState;
              if (!currentState.isDrawerOpen) {
                currentState.openDrawer();
              }
            },
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 0.0,
          floating: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              if (index < data.length) {
                return InkWell(
                  onTap: () {
                    Toast.show(data[index].dapAnDung, context);
                  },
                  child: QuestionItem(data[index], index),
                );
              }

              if (error != null) {
                return ListTile(
                  title: Text(
                    'Có lỗi xảy ra, click vào đây để thử lại!',
                    style: Theme
                        .of(context)
                        .textTheme
                        .body1
                        .copyWith(fontSize: 16.0),
                  ),
                  isThreeLine: false,
                  leading: CircleAvatar(
                    child: Text(':('),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                  ),
                  onTap: () {
                    _loadMore();
                  },
                );
              }

              return Visibility(
                visible: isLoading,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: const SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    ),
                  ),
                ),
              );
            },
            childCount: data.length + 1,
          ),
        ),
      ],
    );
  }

  Future<void> _onReachMaxItem(void _) async {
    // show animation when loaded all data
    _scaffoldKey.currentState
        ?.showSnackBar(
      SnackBar(
        content: Text('Hết rồi!'),
      ),
    )
        ?.closed;
  }

  Future<void> _onError(Object error) async {
    _scaffoldKey.currentState
        ?.showSnackBar(
      SnackBar(
        content: Text('Có lỗi xảy ra, vui lòng thử lại sau!'),
      ),
    )
        ?.closed;
  }
}
