import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/api/data_source/class_data_source.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/logic/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/ui/screens/base_screen_state.dart';
import 'package:thi_trac_nghiem/ui/widget/class_item.dart';
import 'package:thi_trac_nghiem/ui/widget/error_item.dart';
import 'package:thi_trac_nghiem/ui/widget/load_more_item.dart';

class ListClassScreen extends StatefulWidget {
  @override
  _ListClassScreenState createState() => _ListClassScreenState();
}

class _ListClassScreenState extends ListTypeScreenState<String> {
  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  List<String> buildDataSourceParameter() => [];

  @override
  IDataSource<String> initDataSource() => ClassDataSource();

  @deprecated
  @override
  void loadMore() {
    // nothing here
  }

  @override
  Widget buildList(AsyncSnapshot<DataListState<String>> snapshot) {
    final data = snapshot.data.listData;
    final isLoading = snapshot.data.isLoading;
    final error = snapshot.data.error;

    final _data = []
      ..addAll(data)
      ..sort();

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
                return ClassItem(
                  item: _data[index],
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
