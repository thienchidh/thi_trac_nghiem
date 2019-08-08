import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thi_trac_nghiem/logic/bloc/timer_bloc.dart';
import 'package:thi_trac_nghiem/logic/ticker.dart';
import 'package:thi_trac_nghiem/ui/widget/action_timer.dart';
import 'package:thi_trac_nghiem/ui/widget/background_widget.dart';
import 'package:thi_trac_nghiem/ui/widget/timer_widget.dart';

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute
        .of(context)
        .settings
        .arguments;
    assert(arguments is List<dynamic>);
    final List<dynamic> list = arguments as List<dynamic>;
    assert(list.length == 2);

    final int duration = list.first;
    final void Function() onFinished = list.last;

    return Scaffold(
      body: BlocProvider(
        builder: (context) {
          return TimerBloc(
            ticker: Ticker(),
            duration: duration,
            onFinished: () => onFinished(),
          );
        },
        child: Stack(
          children: <Widget>[
            BackgroundWidget(),
            TimerWidget(
              actions: ActionsTimerUpcomingExam(),
            ),
          ],
        ),
      ),
    );
  }
}
