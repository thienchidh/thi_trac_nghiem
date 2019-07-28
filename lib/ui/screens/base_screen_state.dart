import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/logic/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/ui/widget/common_drawer.dart';
import 'package:thi_trac_nghiem/ui/widget/error_item.dart';
import 'package:thi_trac_nghiem/ui/widget/load_more_item.dart';

abstract class BaseScreenState<T> extends State<StatefulWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  DataSource<T> _dataSource;
  DataBloc bloc;
  StreamSubscription<void> subscriptionReachMaxItems;
  StreamSubscription<Object> subscriptionError;

  bool isReachMaxItem = false;

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
    if (isReachMaxItem) {
      return;
    }
    print('logic.bloc.loadMore.add(null)');
    bloc.loadMore.add(null);
  }

  Future<void> refresh() async {
    isReachMaxItem = false;

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
    isReachMaxItem = true;
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

abstract class PageTypeScreenState<T> extends BaseScreenState<T> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

abstract class ListTypeScreenState<T> extends BaseScreenState<T> {
  final scrollController = ScrollController();
  bool isHideFloatingButton = true;

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
      if (isHideFloatingButton) {
        setState(() => isHideFloatingButton = false);
      }
    } else if (position.userScrollDirection == ScrollDirection.forward) {
      if (!isHideFloatingButton) {
        setState(() => isHideFloatingButton = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: Visibility(
        visible: !isHideFloatingButton,
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
        child: StreamBuilder<DataListState<T>>(
          stream: bloc.dataList,
          builder:
              (BuildContext context, AsyncSnapshot<DataListState<T>> snapshot) {
            if (snapshot.hasError) {
              return ErrorItem(
                onClick: () => refresh(),
              );
            }

            if (!snapshot.hasData) {
              return LoadMoreItem(
                isVisible: true,
              );
            }

            return buildList(snapshot);
          },
        ),
        onRefresh: () => refresh(),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<DataListState<T>> snapshot);
}
