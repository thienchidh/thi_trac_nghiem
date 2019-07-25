import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thi_trac_nghiem/bloc/timer_bloc.dart';
import 'package:thi_trac_nghiem/bloc/timer_event.dart';
import 'package:thi_trac_nghiem/bloc/timer_state.dart';
import 'package:thi_trac_nghiem/logic/ticker.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int _numOfSecond = ModalRoute.of(context).settings.arguments;

    return BlocProvider(
      builder: (context) {
        return TimerBloc(
          ticker: Ticker(),
          duration: _numOfSecond,
        );
      },
      child: Timer(),
    );
  }
}

class Timer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: TimerMini(),
              ),
              BlocBuilder<TimerBloc, TimerState>(
                condition: (previousState, currentState) =>
                    currentState.runtimeType != previousState.runtimeType,
                builder: (context, state) => Actions(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerMini extends StatelessWidget {
  static const TextStyle timerTextStyle = TextStyle(
    fontSize: 35,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          return _makeTimeFromSecond(state.duration);
        },
      ),
    );
  }

  Widget _makeTimeFromSecond(int totalSecond) {
    final day = (totalSecond / 60 / 60 / 24).floor();
    final hour = (totalSecond / 60 / 60 % 24).floor();
    final minute = (totalSecond / 60 % 60).floor();
    final second = (totalSecond % 60);

    final String dayStr = day.toString().padLeft(2, '0');
    final String hourStr = hour.toString().padLeft(2, '0');
    final String minutesStr = minute.toString().padLeft(2, '0');
    final String secondsStr = second.toString().padLeft(2, '0');

    return Text(
      (day != 0) ? '$dayStr Ngày' : '$hourStr:$minutesStr:$secondsStr',
      style: timerTextStyle,
    );
  }
}

class Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        timerBloc: BlocProvider.of<TimerBloc>(context),
      ),
    );
  }

  List<Widget> _mapStateToActionButtons({
    TimerBloc timerBloc,
  }) {
    final TimerState state = timerBloc.currentState;
    if (state is Ready) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () => timerBloc.dispatch(Start(duration: state.duration)),
        ),
      ];
    }
    if (state is Running) {
      return [
        FloatingActionButton(
          child: Icon(Icons.pause),
          onPressed: () => timerBloc.dispatch(Pause()),
        ),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.dispatch(Reset()),
        ),
      ];
    }
    if (state is Paused) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () => timerBloc.dispatch(Resume()),
        ),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.dispatch(Reset()),
        ),
      ];
    }
    if (state is Finished) {
      return [
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.dispatch(Reset()),
        ),
      ];
    }
    return [];
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            Color.fromRGBO(72, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(184, 189, 245, 0.7)
          ],
          [
            Color.fromRGBO(72, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(172, 182, 219, 0.7)
          ],
          [
            Color.fromRGBO(72, 73, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(190, 238, 246, 0.7)
          ],
        ],
        durations: [19440, 10800, 6000],
        heightPercentages: [0.03, 0.01, 0.02],
        gradientBegin: Alignment.bottomCenter,
        gradientEnd: Alignment.topCenter,
      ),
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 25,
      backgroundColor: Colors.blue[50],
    );
  }
}
