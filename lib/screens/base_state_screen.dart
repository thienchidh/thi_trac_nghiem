import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/widget/common_drawer.dart';

abstract class BaseScreenState<T> extends State<StatefulWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  DataSource<T> _dataSource;
  DataBloc bloc;
  StreamSubscription<void> subscriptionReachMaxItems;
  StreamSubscription<Object> subscriptionError;

  bool _isReachMaxItem = false;

  DataSource<T> initDataSource();

  List<String> buildDataSourceParameter();

  BaseScreenState() {
    _dataSource = initDataSource();
    bloc = DataBloc<T>(_dataSource);

    // listen error, reach max items
    subscriptionReachMaxItems = bloc.loadedAllData.listen(onReachMaxItem);
    subscriptionError = bloc.error.listen(onError);
  }

  void loadMore() {
    if (_isReachMaxItem) {
      return;
    }
    print('bloc.loadMore.add(null)');
    bloc.loadMore.add(null);
  }

  Future<void> refresh() async {
    _isReachMaxItem = false;

    _dataSource.setParameter(
      parameter: buildDataSourceParameter(),
    );
    await bloc.refresh();
  }

  @override
  void dispose() {
    Future.wait([
      bloc.dispose(),
      subscriptionError.cancel(),
      subscriptionReachMaxItems.cancel(),
    ]);
    super.dispose();
  }

  Future<void> onReachMaxItem(void _) async {
    // show animation when loaded all data
    _isReachMaxItem = true;
    await scaffoldKey.currentState
        ?.showSnackBar(
          SnackBar(
            content: Text('Hết rồi!'),
          ),
        )
        ?.closed;
  }

  Future<void> onError(Object error) async {
    await scaffoldKey.currentState
        ?.showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra, vui lòng thử lại sau!'),
          ),
        )
        ?.closed;
  }
}

////

abstract class ListTypeScreenState<T> extends BaseScreenState<T> {
  final scrollController = ScrollController();
  bool isShowFloatingButton = false;

  static const _offsetVisibleThreshold = 100;

  ListTypeScreenState() : super() {
    // add listener to scroll controller
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _onScroll() async {
    final offset = scrollController.offset;
    final position = scrollController.position;
    final maxScrollExtent = position.maxScrollExtent;

    // if scroll to bottom of list, then load next page
    if (offset + _offsetVisibleThreshold >= maxScrollExtent) {
      loadMore();
    }

    if (position.userScrollDirection == ScrollDirection.reverse) {
      if (isShowFloatingButton) {
        setState(() => isShowFloatingButton = false);
      }
    } else if (position.userScrollDirection == ScrollDirection.forward) {
      if (!isShowFloatingButton) {
        setState(() => isShowFloatingButton = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: Visibility(
        visible: !isShowFloatingButton,
        child: FloatingActionButton(
          tooltip: 'Scroll to top',
          mini: true,
          child: Icon(
            Icons.keyboard_arrow_up,
          ),
          onPressed: () {
            scrollController.animateTo(
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
          child: StreamBuilder<DataListState<T>>(
            stream: bloc.dataList,
            builder: (BuildContext context,
                AsyncSnapshot<DataListState<T>> snapshot) {
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

              return buildList(snapshot);
            },
          ),
        ),
        onRefresh: () => refresh(),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<DataListState<T>> snapshot);
}

abstract class PageTypeScreenState<T> extends BaseScreenState<T> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
