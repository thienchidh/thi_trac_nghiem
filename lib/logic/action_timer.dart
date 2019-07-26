import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thi_trac_nghiem/bloc/timer_bloc.dart';
import 'package:thi_trac_nghiem/bloc/timer_event.dart';
import 'package:thi_trac_nghiem/bloc/timer_state.dart';

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

  List<Widget> onTimerFinished(
    TimerBloc timerBloc,
    TimerFinished state, {
    arguments,
  });

  ActionsTimer newInstance();
}

class ActionsTimerUpcomingExam extends ActionsTimer {
  @override
  List<Widget> onTimerReady(TimerBloc timerBloc, TimerReady state) {
    print('ActionsTimerBeforeStart.onReady');
    timerBloc.dispatch(Start(duration: state.duration));
    return [];
  }

  @override
  List<Widget> onTimerRunning(TimerBloc timerBloc, TimerRunning state) => [];

  @override
  List<Widget> onTimerPaused(TimerBloc timerBloc, TimerPaused state) => [];

  @override
  List<Widget> onTimerFinished(
    TimerBloc timerBloc,
    TimerFinished state, {
    arguments,
  }) {
    // TODO get all questions from server to client
    print('ActionsTimerBeforeStart.onTimerFinished');
    return [];
  }

  @override
  ActionsTimer newInstance() => ActionsTimerUpcomingExam();
}

class ActionsTimerRunningExam extends ActionsTimer {
  @override
  List<Widget> onTimerReady(TimerBloc timerBloc, TimerReady state) {
    print('ActionsTimerAfterStart.onTimerReady');
    timerBloc.dispatch(Start(duration: state.duration));
    return [];
  }

  @override
  List<Widget> onTimerRunning(TimerBloc timerBloc, TimerRunning state) => [];

  @override
  List<Widget> onTimerPaused(TimerBloc timerBloc, TimerPaused state) => [];

  @override
  List<Widget> onTimerFinished(
    TimerBloc timerBloc,
    TimerFinished state, {
    arguments,
  }) {
    // TODO push answers from client to server
    print('ActionsTimerAfterStart.onTimerFinished');
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
        onPressed: () => timerBloc.dispatch(Start(duration: state.duration)),
      ),
    ];
  }

  @override
  List<Widget> onTimerRunning(TimerBloc timerBloc, TimerRunning state) {
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

  @override
  List<Widget> onTimerPaused(TimerBloc timerBloc, TimerPaused state) {
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

  @override
  List<Widget> onTimerFinished(
    TimerBloc timerBloc,
    TimerFinished state, {
    arguments,
  }) {
    return [
      FloatingActionButton(
        child: Icon(Icons.replay),
        onPressed: () => timerBloc.dispatch(Reset()),
      ),
    ];
  }

  @override
  ActionsTimer newInstance() => ActionsTimerNormal();
}
