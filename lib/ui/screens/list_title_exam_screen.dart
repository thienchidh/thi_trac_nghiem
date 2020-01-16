import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/api/data_source/exam_data_source.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/logic/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/account.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';
import 'package:thi_trac_nghiem/ui/screens/base_screen_state.dart';
import 'package:thi_trac_nghiem/ui/widget/error_item.dart';
import 'package:thi_trac_nghiem/ui/widget/load_more_item.dart';
import 'package:thi_trac_nghiem/ui/widget/title_exam_item.dart';
import 'package:thi_trac_nghiem/utils/notification_ultis.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class ListTitleExamScreen extends StatefulWidget {
  @override
  _ListTitleExamScreenState createState() => _ListTitleExamScreenState();
}

class _ListTitleExamScreenState extends ListTypeScreenState<Exam> {
  NotificationUltis _notificationUltis;

  _ListTitleExamScreenState() : super() {
    _notificationUltis = NotificationUltis(context);
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  List<String> buildDataSourceParameter() =>
      [UserManagement().curUser.lop, UserManagement().curUser.maso];

  @override
  IDataSource<Exam> initDataSource() => ExamDataSource();

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
                final exam = data[index];
                if (exam.status == Exam.UPCOMING) {
                  if (_computeDuration(exam) > 60) {
                    final timeStart =
                    serverDateFormat.parse(exam.thoiGianBatDau);

                    if (!UserManagement().map.containsKey(timeStart.hashCode)) {
                      _notificationUltis.flutterLocalNotificationsPlugin
                          .schedule(
                        timeStart.hashCode,
                        exam.maLoaiKt,
                        'Kỳ thi ${exam.maLoaiKt} đã bắt đầu',
                        timeStart,
                        _notificationUltis.platformChannelSpecifics,
                        payload: '${timeStart.hashCode}',
                      );
                      UserManagement().map[timeStart.hashCode] = null;
                    }
                  }
                }

                return InkWell(
                  child: TitleExamItem(
                    exam: exam,
                  ),
                  onTap: () {
                    onClickExam(data, index);
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

  void onClickExam(UnmodifiableListView<Exam> data, int index) {
    if (data[index].status == Exam.RUNNING) {
      UserManagement().curExamDoing = data[index];
    }

    if (UserManagement().curUser.userType != UserType.student) {
      // view score when Exam is finished (only teacher)
      if (data[index].status == Exam.FINISHED) {
        UserManagement().curExamDoing = data[index];
        Navigator.pushNamed(context, '/${UIData.LIST_SCORE_ROUTE_NAME}');
      }
    } else {
      // do exam (only student)
      if (data[index].status != Exam.UPCOMING) {
        UserManagement().curExamDoing = data[index];
        Navigator.pushNamed(context, '/${UIData.EXAM_ROUTE_NAME}');
      } else {
        //if(data[index].status == Exam.UPCOMING)

        final duration = _computeDuration(data[index]);

        Navigator.pushNamed(
          context,
          '/${UIData.TIMER_ROUTE_NAME}',
          arguments: [
            duration,
                () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            }
          ],
        );
      }
    }
  }
}

int _computeDuration(Exam exam) {
  final timeStart = serverDateFormat.parse(exam.thoiGianBatDau);
  final timeEnd = serverDateFormat.parse(exam.thoiGianKetThuc);
  final curTime = serverDateFormat.parse(exam.timeserver);

  int duration = 0;
  if (exam.status == Exam.UPCOMING) {
    duration = timeStart
        .difference(curTime)
        .inSeconds;
    duration = max(duration, 1);
  } else if (exam.status == Exam.RUNNING) {
    duration = timeEnd
        .difference(curTime)
        .inSeconds;
  } else {
    //Exam.FINISHED
    duration = 0;
  }
  return duration;
}
