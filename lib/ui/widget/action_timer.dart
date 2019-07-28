import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thi_trac_nghiem/logic/bloc/timer_bloc.dart';
import 'package:thi_trac_nghiem/logic/bloc/timer_event.dart';
import 'package:thi_trac_nghiem/logic/bloc/timer_state.dart';

abstract class ActionsTimer extends StatelessWidget {
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
    if (state is TimerReady) {
      return onTimerReady(timerBloc, state);
    }
    if (state is TimerRunning) {
      return onTimerRunning(timerBloc, state);
    }
    if (state is TimerPaused) {
      return onTimerPaused(timerBloc, state);
    }
    if (state is TimerFinished) {
      return onTimerFinished(timerBloc, state);
    }
    return [];
  }

  List<Widget> onTimerReady(TimerBloc timerBloc, TimerReady state);

  List<Widget> onTimerRunning(TimerBloc timerBloc, TimerRunning state);

  List<Widget> onTimerPaused(TimerBloc timerBloc, TimerPaused state);

  List<Widget> onTimerFinished(TimerBloc timerBloc, TimerFinished state);

  ActionsTimer newInstance();
}

class ActionsTimerUpcomingExam extends ActionsTimer {
  @override
  List<Widget> onTimerReady(TimerBloc timerBloc, TimerReady state) {
    return [];
  }

  @override
  List<Widget> onTimerRunning(TimerBloc timerBloc, TimerRunning state) => [];

  @override
  List<Widget> onTimerPaused(TimerBloc timerBloc, TimerPaused state) => [];

  @override
  List<Widget> onTimerFinished(TimerBloc timerBloc, TimerFinished state) {
    return [];
  }

  @override
  ActionsTimer newInstance() => ActionsTimerUpcomingExam();
}

class ActionsTimerRunningExam extends ActionsTimer {
  @override
  List<Widget> onTimerReady(TimerBloc timerBloc, TimerReady state) {
    return [];
  }

  @override
  List<Widget> onTimerRunning(TimerBloc timerBloc, TimerRunning state) => [];

  @override
  List<Widget> onTimerPaused(TimerBloc timerBloc, TimerPaused state) => [];

  @override
  List<Widget> onTimerFinished(TimerBloc timerBloc, TimerFinished state) {
    return [];
  }

  @override
  ActionsTimer newInstance() => ActionsTimerRunningExam();
}

class ActionsTimerNormal extends ActionsTimer {
  @override
  List<Widget> onTimerReady(TimerBloc timerBloc, TimerReady state) {
    return [
      FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () =>
            timerBloc.dispatch(StartTimer(duration: state.duration)),
      ),
    ];
  }

  @override
  List<Widget> onTimerRunning(TimerBloc timerBloc, TimerRunning state) {
    return [
      FloatingActionButton(
        child: Icon(Icons.pause),
        onPressed: () => timerBloc.dispatch(PauseTimer()),
      ),
      FloatingActionButton(
        child: Icon(Icons.replay),
        onPressed: () => timerBloc.dispatch(ResetTimer()),
      ),
    ];
  }

  @override
  List<Widget> onTimerPaused(TimerBloc timerBloc, TimerPaused state) {
    return [
      FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () => timerBloc.dispatch(ResumeTimer()),
      ),
      FloatingActionButton(
        child: Icon(Icons.replay),
        onPressed: () => timerBloc.dispatch(ResetTimer()),
      ),
    ];
  }

  @override
  List<Widget> onTimerFinished(TimerBloc timerBloc, TimerFinished state) {
    return [
      FloatingActionButton(
        child: Icon(Icons.replay),
        onPressed: () => timerBloc.dispatch(ResetTimer()),
      ),
    ];
  }

  @override
  ActionsTimer newInstance() => ActionsTimerNormal();
}
