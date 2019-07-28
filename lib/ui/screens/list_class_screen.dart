import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/api/data_source/class_data_source.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/logic/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/ui/screens/base_screen_state.dart';
import 'package:thi_trac_nghiem/ui/widget/error_item.dart';
import 'package:thi_trac_nghiem/ui/widget/load_more_item.dart';

class ListClassScreen extends StatefulWidget {
  @override
  _ListClassScreenState createState() => _ListClassScreenState();
}

class _ListClassScreenState extends BaseScreenState<String> {
  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  List<String> buildDataSourceParameter() => [];

  @override
  DataSource<String> initDataSource() => ClassDataSource();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DataListState<String>>(
      stream: bloc.dataList,
      builder: (BuildContext context,
          AsyncSnapshot<DataListState<String>> snapshot) {
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
    );
  }

  Widget buildList(AsyncSnapshot<DataListState<String>> snapshot) {
    final data = snapshot.data.listData;
    final isLoading = snapshot.data.isLoading;
    final error = snapshot.data.error;

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < data.length) {
                return DropdownMenuItem<String>(
                  value: data[index],
                  child: Text(data[index]),
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
