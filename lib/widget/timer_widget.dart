import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thi_trac_nghiem/bloc/timer_bloc.dart';
import 'package:thi_trac_nghiem/bloc/timer_state.dart';
import 'package:thi_trac_nghiem/logic/action_timer.dart';

class TimerWidget extends StatelessWidget {
  final ActionsTimer _actions;

  TimerWidget({@required actions})
      : assert(actions != null),
        _actions = actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) => _makeTimeFromSecond(state.duration),
          ),
        ),
        BlocBuilder<TimerBloc, TimerState>(
          condition: (previousState, currentState) =>
              currentState.runtimeType != previousState.runtimeType,
          builder: (context, state) {
            return _actions.newInstance();
          },
        ),
      ],
    );
  }
}

/// start functions area
const TextStyle _timerTextStyle = TextStyle(
  fontSize: 35,
);

Widget _makeTimeFromSecond(final int totalSecond) {
  final day = (totalSecond / 60 / 60 / 24).floor();
  final hour = (totalSecond / 60 / 60 % 24).floor();
  final minute = (totalSecond / 60 % 60).floor();
  final second = (totalSecond % 60);

  final dayStr = day.toString().padLeft(2, '0');
  final hourStr = hour.toString().padLeft(2, '0');
  final minutesStr = minute.toString().padLeft(2, '0');
  final secondsStr = second.toString().padLeft(2, '0');

  return Text(
    (day != 0) ? '$dayStr Ngày' : '$hourStr:$minutesStr:$secondsStr',
    style: _timerTextStyle,
  );
}

/// end functions area
