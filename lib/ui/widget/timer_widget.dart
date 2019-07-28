import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/logic/bloc/timer_bloc.dart';
import 'package:thi_trac_nghiem/logic/bloc/timer_state.dart';
import 'package:thi_trac_nghiem/ui/widget/action_timer.dart';

class TimerWidget extends StatelessWidget {
  final ActionsTimer _actions;

  final TextStyle _timerTextStyle;

  const TimerWidget({
    Key key,
    @required actions,
    timerTextStyle = const TextStyle(fontSize: 35),
  })  : assert(actions != null),
        _actions = actions,
        _timerTextStyle = timerTextStyle,
        super(key: key);

  Widget _makeTimeFromSecond(final int totalSecond) {
    final day = (totalSecond / 60 / 60 / 24).floor();
    final hour = (totalSecond / 60 / 60 % 24).floor();
    final minute = (totalSecond / 60 % 60).floor();
    final second = (totalSecond % 60);

    final dayStr = day.toString().padLeft(2, '0');
    final hourStr = hour.toString().padLeft(2, '0');
    final minutesStr = minute.toString().padLeft(2, '0');
    final secondsStr = second.toString().padLeft(2, '0');

    if (day > 0) {
      if (day <= 10) {
        return Text(
          '$dayStr ngày $hourStr giờ',
          style: _timerTextStyle,
        );
      }

      final DateTime timeDest = DateTime.now().add(Duration(
        days: day,
        hours: hour,
        minutes: minute,
        seconds: second,
      ));

      return Text(
        '${localDateFormat.format(timeDest)}',
        style: _timerTextStyle,
      );
    }
    return Text(
      '$hourStr:$minutesStr:$secondsStr',
      style: _timerTextStyle,
    );
  }

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
