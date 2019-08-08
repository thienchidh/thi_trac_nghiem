import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/api/data_source/list_exam_data_source.dart';
import 'package:thi_trac_nghiem/logic/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/exam_questions.dart';
import 'package:thi_trac_nghiem/ui/screens/base_screen_state.dart';
import 'package:thi_trac_nghiem/ui/widget/error_item.dart';
import 'package:thi_trac_nghiem/ui/widget/exam_item.dart';
import 'package:thi_trac_nghiem/ui/widget/load_more_item.dart';

class ListExamScreenForView extends StatefulWidget {
  @override
  _ListExamScreenForViewState createState() => _ListExamScreenForViewState();
}

class _ListExamScreenForViewState extends ListTypeScreenState<ExamQuestions> {
  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  List<String> buildDataSourceParameter() => [UserManagement().curUser.maso];

  @override
  IDataSource<ExamQuestions> initDataSource() => ListExamDataSource();

  @override
  Widget buildList(AsyncSnapshot<DataListState<ExamQuestions>> snapshot) {
    final data = snapshot.data.listData;
    final isLoading = snapshot.data.isLoading;
    final error = snapshot.data.error;

    return CustomScrollView(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          title: Text(
            ModalRoute.of(context).settings.name.substring(1),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < data.length) {
                return ExamItem(
                  item: data[index],
                );
              }

              if (!isReachMaxItem) {
                loadMore();
              }

              if (error != null) {
                return ErrorItem(
                  onClick: () => refresh(),
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
