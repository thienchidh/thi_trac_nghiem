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
    @required ActionsTimer actions,
    timerTextStyle = const TextStyle(fontSize: 25),
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

    final DateTime timeNow = DateTime.now();
    final DateTime timeDest = timeNow.add(Duration(
      days: day,
      hours: hour,
      minutes: minute,
      seconds: second,
    ));

    String text;
    if (day > 0) {
      if (day <= 10) {
        text = '$dayStr ngày $hourStr giờ';
      } else {
        text = localDateFormat.format(timeDest);
      }
    } else {
      text = '$hourStr:$minutesStr:$secondsStr';
    }

    return Text(
      text,
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
