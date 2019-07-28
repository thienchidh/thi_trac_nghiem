import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/logic/bloc/timer_bloc.dart';
import 'package:thi_trac_nghiem/logic/ticker.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';
import 'package:thi_trac_nghiem/ui/widget/action_timer.dart';
import 'package:thi_trac_nghiem/ui/widget/timer_widget.dart';
import 'package:toast/toast.dart';

class TitleExamItem extends StatelessWidget {
  final Exam exam;

  TitleExamItem({this.exam})
      : assert(exam != null),
        super();

  @override
  Widget build(BuildContext context) {
    final timeStart = serverDateFormat.parse(exam.thoiGianBatDau);
    final timeEnd = serverDateFormat.parse(exam.thoiGianKetThuc);

    int distance = 0;
    if (exam.status == Exam.UPCOMING) {
      distance = timeStart.difference(DateTime.now()).inSeconds;
    } else if (exam.status == Exam.RUNNING) {
      distance = timeEnd.difference(DateTime.now()).inSeconds;
    } else {
      distance = 0;
    }
    distance = max(distance, 0);

    return Container(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            '${exam.lop}',
            style: TextStyle(
              fontSize: 10.0,
            ),
          ),
        ),
        title: Text('${exam.maLoaiKt}'),
        trailing: Text('${exam.status}'),
        subtitle: BlocProvider(
          builder: (context) {
            return TimerBloc(
              ticker: Ticker(),
              voidCallbackOnFinished: () {
                Toast.show(
                    'Kỳ thi ${exam.maLoaiKt} đã bắt đầu, hãy vào làm ngay nào.',
                    context);
              },
              duration: distance,
            );
          },
          child: TimerWidget(
            timerTextStyle: const TextStyle(
              fontSize: 14.0,
            ),
            actions: ActionsTimerRunningExam(),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
