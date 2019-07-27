import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:synchronized/synchronized.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/api/data_source/question_data_source.dart';
import 'package:thi_trac_nghiem/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';
import 'package:thi_trac_nghiem/screens/base_state_screen.dart';
import 'package:thi_trac_nghiem/widget/question_item.dart';
import 'package:thi_trac_nghiem/widget/search_bar.dart';
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
  List<String> buildDataSourceParameter() => [_keyWord];

  @override
  DataSource<Question> initDataSource() => QuestionDataSource();

  @override
  Widget buildList(AsyncSnapshot<DataListState> snapshot) {
    final data = snapshot.data.listData;
    final isLoading = snapshot.data.isLoading;
    final error = snapshot.data.error;

    return CustomScrollView(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          title: SearchBar(
            performSearch: _search,
            performOpenDrawer: () {
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
                    loadMore();
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
}
