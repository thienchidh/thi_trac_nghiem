import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/api/data_source/exam_data_source.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/logic/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';
import 'package:thi_trac_nghiem/ui/screens/base_screen_state.dart';
import 'package:thi_trac_nghiem/ui/widget/error_item.dart';
import 'package:thi_trac_nghiem/ui/widget/load_more_item.dart';
import 'package:thi_trac_nghiem/ui/widget/title_exam_item.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class ListTitleExamScreen extends StatefulWidget {
  @override
  _ListTitleExamScreenState createState() => _ListTitleExamScreenState();
}

class _ListTitleExamScreenState extends ListTypeScreenState<Exam> {
  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  List<String> buildDataSourceParameter() => [UserManagement().curUser.lop];

  @override
  DataSource<Exam> initDataSource() => ExamDataSource();

  @deprecated
  @override
  void loadMore() {
    // nothing here
  }

  @override
  Widget buildList(AsyncSnapshot<DataListState<Exam>> snapshot) {
    final data = snapshot.data.listData;
    final isLoading = snapshot.data.isLoading;
    final error = snapshot.data.error;

    return CustomScrollView(
      controller: scrollController,
      //physics: AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          title: Text(
            ModalRoute.of(context).settings.name,
          ),
          pinned: true,
          floating: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < data.length) {
                return InkWell(
                  child: TitleExamItem(
                    exam: data[index],
                  ),
                  onTap: () {
                    if (data[index].status == Exam.RUNNING) {
                      UserManagement().curExam = data[index];
                      Navigator.pushReplacementNamed(
                          context, '/${UIData.EXAM_ROUTE_NAME}');
                    }
                  },
                );
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
