import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:synchronized/synchronized.dart';
import 'package:thi_trac_nghiem/api/api_question_data_source.dart';
import 'package:thi_trac_nghiem/bloc/question_bloc.dart';
import 'package:thi_trac_nghiem/model/account.dart';
import 'package:thi_trac_nghiem/widget/common_drawer.dart';
import 'package:thi_trac_nghiem/widget/question_item.dart';
import 'package:thi_trac_nghiem/widget/search_bar.dart';
import 'package:toast/toast.dart';

class SearchScreen extends StatefulWidget {
  final User user;

  const SearchScreen(this.user, {Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _lock = Lock(reentrant: true);

  final _scrollController = ScrollController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const _offsetVisibleThreshold = 50;

  ///
  /// pass [QuestionDataSource] to [QuestionBloc]'s constructor
  ///
  QuestionBloc _bloc;
  StreamSubscription<void> _subscriptionReachMaxItems;
  StreamSubscription<Object> _subscriptionError;
  bool isShowAppbar;

  _SearchScreenState({this.isShowAppbar = true}) {
    _bloc = QuestionBloc(QuestionDataSource());

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
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
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
              _scrollController
                  .animateTo(
                0.0,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 10000),
              )
                  .then((x) => setState(() => isShowAppbar = !isShowAppbar));
            },
          ),
        ),
        appBar: !isShowAppbar
            ? PreferredSize(
          preferredSize: Size(0.0, 0.0),
          child: Container(
            color: Theme
                .of(context)
                .primaryColor,
          ),
        )
            : AppBar(
          title: SearchBar(
              performSearch: _search,
              performOpenDrawer: () {
                final currentState = _scaffoldKey.currentState;
                if (!currentState.isDrawerOpen) {
                  currentState.openDrawer();
                }
              }),
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 0.0,
        ),
        drawer: CommonDrawer(widget.user),
        body: RefreshIndicator(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: StreamBuilder<QuestionListState>(
              stream: _bloc.questionList,
              builder: (BuildContext context,
                  AsyncSnapshot<QuestionListState> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return _buildList(snapshot);
              },
            ),
          ),
          onRefresh: _bloc.refresh,
        ),
      ),
    );
  }

  @override
  void dispose() async {
    _scrollController.dispose();
    await Future.wait([
      _bloc.dispose(),
      _subscriptionError.cancel(),
      _subscriptionReachMaxItems.cancel(),
    ]);

    super.dispose();
  }

  ListView _buildList(AsyncSnapshot<QuestionListState> snapshot) {
    final data = snapshot.data.question;
    final isLoading = snapshot.data.isLoading;
    final error = snapshot.data.error;

    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {
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
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
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

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Visibility(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
              visible: isLoading,
            ),
          ),
        );
      },
      itemCount: data.length + 1,
      separatorBuilder: (BuildContext context, int index) => Divider(),
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

  Future<bool> _willPopCallback() async {
    if (_scaffoldKey.currentState.isDrawerOpen) {
      return true;
    }
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(
              "Are you sure you want to quit the quiz? All your progress will be lost."),
          title: Text("Warning!"),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
