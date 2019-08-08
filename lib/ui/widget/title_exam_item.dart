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

class TitleExamItem extends StatefulWidget {
  final Exam exam;

  TitleExamItem({this.exam})
      : assert(exam != null),
        super();

  @override
  _TitleExamItemState createState() => _TitleExamItemState();
}

class _TitleExamItemState extends State<TitleExamItem> {
  @override
  Widget build(BuildContext context) {
    final exam = widget.exam;
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

    return ListTile(
      leading: CircleAvatar(
        child: Text(
          '${exam.lop}',
          style: TextStyle(
            fontSize: 10.0,
          ),
        ),
      ),
      title: Center(
        child: Text('${exam.maLoaiKt} - ${exam.tenBaiThi}'),
      ),
      trailing: Text('${exam.status}'),
      subtitle: BlocProvider(
        builder: (context) {
          return TimerBloc(
            ticker: Ticker(),
            onFinished: () => _onFinished(),
            duration: duration,
          );
        },
        child: TimerWidget(
          timerTextStyle: const TextStyle(
            fontSize: 14.0,
          ),
          actions: ActionsTimerRunningExam(),
        ),
      ),
    );
  }

  void _onFinished() {
    setState(() {
      widget.exam.status = Exam.RUNNING;
    });

    Toast.show(
        'Kỳ thi ${widget.exam
            .maLoaiKt} đã bắt đầu, các bạn hãy vào làm ngay nào.',
        context);
  }
}
