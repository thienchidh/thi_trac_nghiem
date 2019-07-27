import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:thi_trac_nghiem/api/data_source/favorite_data_source.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';
import 'package:thi_trac_nghiem/widget/question_item.dart';
import 'package:toast/toast.dart';

import 'base_state_screen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ListTypeScreenState<Question> {
  @override
  DataSource<Question> initDataSource() => FavoriteDataSource();

  @override
  List<String> buildDataSourceParameter() => [UserManagement().curUser.maso];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Widget buildList(AsyncSnapshot<DataListState> snapshot) {
    final data = snapshot.data.listData;
    final isLoading = snapshot.data.isLoading;
    final error = snapshot.data.error;

    return CustomScrollView(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          // TODO
          title: Text('demo'),
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
                    style: Theme.of(context)
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
