import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/api/data_source/question_data_source.dart';
import 'package:thi_trac_nghiem/logic/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';
import 'package:thi_trac_nghiem/ui/screens/base_screen_state.dart';
import 'package:thi_trac_nghiem/ui/widget/error_item.dart';
import 'package:thi_trac_nghiem/ui/widget/load_more_item.dart';
import 'package:thi_trac_nghiem/ui/widget/question_item.dart';
import 'package:thi_trac_nghiem/ui/widget/search_bar.dart';
import 'package:toast/toast.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ListTypeScreenState<Question> {
  final _lock = Lock(reentrant: true);

  String _keyWord;

  @override
  void initState() {
    super.initState();

    _search('');
  }

  Future<void> _search(String keyWord) async {
    await _lock.synchronized(() async {
      _keyWord = keyWord;
      await refresh();
    });
  }

  @override
  List<String> buildDataSourceParameter() =>
      [_keyWord, UserManagement().curUser.maso];

  @override
  IDataSource<Question> initDataSource() => QuestionDataSource();

  @override
  Widget buildList(AsyncSnapshot<DataListState<Question>> snapshot) {
    final data = snapshot.data.listData;
    final isLoading = snapshot.data.isLoading;
    final error = snapshot.data.error;

    return CustomScrollView(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          title: SearchBar(
            onSearch: _search,
            onOpenDrawer: () {
              final currentState = scaffoldKey.currentState;
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
                return ErrorItem(
                  onClick: () => loadMore(),
                );
              }
              return LoadMoreItem(
                isVisible: isLoading,
              );
            },
            childCount: data.length + 1,
          ),
        ),
      ],
    );
  }
}
