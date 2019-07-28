import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thi_trac_nghiem/logic/bloc/timer_bloc.dart';
import 'package:thi_trac_nghiem/logic/ticker.dart';
import 'package:thi_trac_nghiem/ui/widget/action_timer.dart';
import 'package:thi_trac_nghiem/ui/widget/background_widget.dart';
import 'package:thi_trac_nghiem/ui/widget/timer_widget.dart';
import 'package:toast/toast.dart';

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int _numOfSecond = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: BlocProvider(
        builder: (context) {
          return TimerBloc(
            ticker: Ticker(),
            duration: _numOfSecond,
            voidCallbackOnFinished: () {
              Toast.show('finished...', context);
            },
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
