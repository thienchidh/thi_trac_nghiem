import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/api/data_source/student_data_source.dart';
import 'package:thi_trac_nghiem/logic/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';
import 'package:thi_trac_nghiem/ui/screens/base_screen_state.dart';
import 'package:thi_trac_nghiem/ui/widget/error_item.dart';
import 'package:thi_trac_nghiem/ui/widget/load_more_item.dart';
import 'package:thi_trac_nghiem/ui/widget/student_item.dart';

class ListStudentScreen extends StatefulWidget {
  @override
  _ListStudentScreenState createState() => _ListStudentScreenState();
}

class _ListStudentScreenState extends ListTypeScreenState<Student> {
  @override
  void initState() {
    super.initState();
    refresh();
  }

  @deprecated
  @override
  void loadMore() {
    // nothing here
  }

  @override
  List<String> buildDataSourceParameter() => [UserManagement().curUser.lop];

  @override
  Widget buildList(AsyncSnapshot<DataListState<Student>> snapshot) {
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
                return StudentItem(
                  student: data[index],
                  index: index,
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

  @override
  IDataSource<Student> initDataSource() => StudentDataSource();
}
