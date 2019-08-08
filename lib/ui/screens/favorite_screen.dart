import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/api/data_source/favorite_data_source.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/logic/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';
import 'package:thi_trac_nghiem/ui/widget/error_item.dart';
import 'package:thi_trac_nghiem/ui/widget/load_more_item.dart';
import 'package:thi_trac_nghiem/ui/widget/question_item.dart';
import 'package:toast/toast.dart';

import 'base_screen_state.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ListTypeScreenState<Question> {
  @override
  IDataSource<Question> initDataSource() => FavoriteDataSource();

  @override
  List<String> buildDataSourceParameter() => [UserManagement().curUser.maso];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Widget buildList(AsyncSnapshot<DataListState<Question>> snapshot) {
    final data = snapshot.data.listData;
    final isLoading = snapshot.data.isLoading;
    final error = snapshot.data.error;

    return CustomScrollView(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          title: Text(
            ModalRoute
                .of(context)
                .settings
                .name
                .substring(1),
          ),
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
